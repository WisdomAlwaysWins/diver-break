//
//  UpdateParticipantView.swift
//  diver-break
//
//  Created by J on 4/13/25.
//

import SwiftUI

struct UpdateParticipantView: View {
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var roleViewModel: RoleAssignmentViewModel
    @StateObject private var participantViewModel: ParticipantViewModel

    @FocusState private var focusedId: UUID?
    @State private var lastFocusedId: UUID?
    @State private var scrollTarget: UUID?
    @State private var isExpanded = false
    @State private var validationResult: SubmissionValidationResult? = nil

    init(existingParticipants: [Participant]) {
        _participantViewModel = StateObject(wrappedValue: ParticipantViewModel(
            existingParticipants: existingParticipants,
            mode: .update
        ))
    }

    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            contentView
        }
        .alert("입력 조건이 맞지 않습니다", isPresented: .constant(validationResult != nil)) {
            Button("확인", role: .cancel) {
                validationResult = nil
            }
        } message: {
            Text(alertMessage)
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - View 구성
private extension UpdateParticipantView {
    var backgroundView: some View {
        Color(.systemBackground)
            .ignoresSafeArea()
            .onTapGesture {
                focusedId = nil
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }

    var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            navigationBar
            headerArea
                .padding(.horizontal)
                .padding(.top, 20)
            existingList
                .padding(.horizontal, 20)
            participantList
        }
        .padding(.bottom, 20)
    }

    var navigationBar: some View {
        CustomNavigationBar(
            isDisplayLeftBtn: true,
            isDisplayRightBtn: true,
            leftBtnAction: { pathModel.pop() },
            rightBtnAction: handleSubmit,
            leftBtnType: .back,
            rightBtnType: .play,
            rightBtnColor: .diverBlue
        )
    }

    var headerArea: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("닉네임을 추가할 수 있어요.")
                .font(.title).fontWeight(.medium)
        }
        .padding(20)
    }

    var existingList: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Text("기존 참여자 \(participantViewModel.existingParticipants.count)명")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
            }

            if isExpanded {
                List(participantViewModel.existingParticipants) { participant in
                    Text(participant.name)
                }
                .frame(height: CGFloat(participantViewModel.existingParticipants.count * 44))
                .listStyle(.plain)
                .scrollDisabled(true)
            }
        }
    }

    var participantList: some View {
        ParticipantListView(
            participants: $participantViewModel.participants,
            isDuplicate: { participantViewModel.isNameDuplicated(at: $0) },
            onSubmit: handleSubmitField,
            onDelete: participantViewModel.removeParticipant(at:),
            onAdd: {
                participantViewModel.addParticipant()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if let last = participantViewModel.participants.last {
                        focusedId = last.id
                        scrollTarget = last.id
                    }
                }
            },
            focusedId: $focusedId,
            scrollTarget: $scrollTarget,
            lastFocusedId: $lastFocusedId
        )
    }

    var alertMessage: String {
        switch validationResult {
        case .notEnough:
            return "참가자를 한 명 이상 추가해주세요."
        case .duplicated:
            return "중복된 이름이 존재합니다. 이름을 수정해주세요."
        default:
            return ""
        }
    }
    
    func handleSubmitField(index: Int, participant: Participant) {
        let trimmed = participant.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            participantViewModel.removeParticipant(at: index)
        } else if let nextId = participantViewModel.nextId(after: participant.id) {
            focusedId = nextId
            scrollTarget = nextId
        }
    }

    func handleSubmit() {
        switch participantViewModel.validateSubmission() {
        case .valid:
            roleViewModel.assignRolesToNewParticipants(participantViewModel.participants)

            let newAssigned = roleViewModel.participants.filter { new in
                participantViewModel.participants.contains { $0.name == new.name }
            }

            pathModel.push(.roleReveal(participants: newAssigned))

        case .notEnough, .duplicated:
            validationResult = participantViewModel.validateSubmission()
        }
    }
}


#Preview {
    UpdateParticipantPreviewWrapper()
        .environmentObject(PathModel())
        .environmentObject(RoleAssignmentViewModel())
}

private struct UpdateParticipantPreviewWrapper: View {
    var body: some View {
        UpdateParticipantView(existingParticipants: [
            Participant(name: "HappyJay"),
            Participant(name: "Gigi"),
            Participant(name: "Moo")
        ])
    }
}
