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
    @StateObject private var viewModel: UpdateParticipantViewModel
    

    @FocusState private var focusedId: UUID?
    @State private var lastFocusedId: UUID?
    @State private var scrollTarget: UUID?
    @State private var isExpanded = false
    @State private var isAlertPresented = false

    init(existingParticipants: [Participant]) {
        _viewModel = StateObject(wrappedValue: UpdateParticipantViewModel(existingParticipants: existingParticipants))
    }

    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            contentView
        }
        .alert("입력 조건이 맞지 않습니다", isPresented: $isAlertPresented) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .navigationBarBackButtonHidden(true)
    }
}

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
            rightBtnType: .play
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
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 8) {

                    Text("기존 참여자 \(viewModel.existingParticipants.count)명")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.gray)
                        .frame(width: 12)
                    
                    
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .contentShape(Rectangle())
            }

            if isExpanded {
                List {
                    ForEach(viewModel.existingParticipants) { participant in
                        Text(participant.name)
                    }
                }
                .frame(height: CGFloat(viewModel.existingParticipants.count * 44)) // 높이 고정 (줄당 대략 44)
                .listStyle(.plain)
                .scrollDisabled(true)
//                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    var participantList: some View {
        ParticipantListView(
            participants: $viewModel.newParticipants,
            isDuplicate: { viewModel.isNameDuplicated(at: $0) },
            onSubmit: handleSubmitField,
            onDelete: viewModel.removeParticipant,
            onAdd: {
                viewModel.addParticipant()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if let last = viewModel.newParticipants.last {
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
        let validNewParticipants = viewModel.newParticipants.filter {
            !$0.name.trimmingCharacters(in: .whitespaces).isEmpty
        }

        if validNewParticipants.isEmpty {
            return "참가자를 한 명 이상 추가해주세요."
        } else {
            return "중복된 이름이 존재합니다. 이름을 수정해주세요."
        }
    }
    
    func handleSubmit() {
        let trimmedNew = viewModel.newParticipants
            .map { $0.name.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        let existingNames = viewModel.existingParticipants
            .map { $0.name.trimmingCharacters(in: .whitespaces) }

        let duplicatesWithExisting = trimmedNew.filter { existingNames.contains($0) }
        let hasInternalDuplicates = Set(trimmedNew).count != trimmedNew.count

        guard !trimmedNew.isEmpty, duplicatesWithExisting.isEmpty, !hasInternalDuplicates else {
            isAlertPresented = true
            return
        }

        print("💾 기존 인원: \(roleViewModel.participants.map { $0.name })")
        print("➕ 추가 인원: \(viewModel.newParticipants.map { $0.name })")

        roleViewModel.assignRolesToNewParticipants(viewModel.newParticipants)
        
        let newAssigned = roleViewModel.participants.filter { new in
            viewModel.newParticipants.contains(where: { $0.name == new.name })
        }

        pathModel.push(.roleReveal(participants: newAssigned))

//        pathModel.push(.main)
    }
    

    func handleSubmitField(index: Int, participant: Participant) {
        let trimmed = participant.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            viewModel.removeParticipant(at: index)
        } else if let nextId = viewModel.nextParticipantId(after: participant.id) {
            focusedId = nextId
            scrollTarget = nextId
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
