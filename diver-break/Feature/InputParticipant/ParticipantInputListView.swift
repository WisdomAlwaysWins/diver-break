//
//  ㅖ
//  diver-break
//
//  Created by J on 4/12/25.
//

import SwiftUI

// MARK: - 참가자 입력 화면
struct ParticipantInputListView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject private var inputViewModel = ParticipantInputListViewModel()
    @StateObject private var roleViewModel = RoleAssignmentViewModel()

    @FocusState private var focusedId: UUID?
    @State private var lastFocusedId: UUID?
    @State private var scrollTarget: UUID?
    @State private var isAlertPresented = false

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
        .navigationBarHidden(true)
    }
}

// MARK: - View
private extension ParticipantInputListView {
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
            participantList
        }
    }

    var navigationBar: some View {
        CustomNavigationBar(
            isDisplayLeftBtn: true,
            isDisplayRightBtn: true,
            leftBtnAction: { print("도움말 눌림") },
            rightBtnAction: handlePlayTapped,
//            leftBtnType: .help,
            leftBtnType: nil,
            rightBtnType: .play,
            rightBtnColor: canProceed ? .diverBlue : .diverIconGray
        )
    }

    var headerArea: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 0) {
                    Text("조커는 딱 ")
                    Text("1").foregroundColor(.diverBlue)
                    Text("명입니다.")
                }
                .font(.title).fontWeight(.medium)

                Text("역할은 무작위로 정해집니다.")
                    .font(.title).fontWeight(.medium)
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 0) {
                    Text("팀원은 최소 ")
                    Text("3").foregroundColor(.diverBlue)
                    Text("명이 필요합니다.")
                }
                .font(.subheadline).fontWeight(.medium)

                Text("아래에 팀원들의 이름을 작성해주세요.")
                    .font(.subheadline).fontWeight(.medium)
            }
        }
        .padding(20)
    }
    
    var participantList: some View {
        ParticipantListView(
            participants: $inputViewModel.tempParticipants,
            isDuplicate: { inputViewModel.isNameDuplicated(at: $0) },
            onSubmit: handleSubmit,
            onDelete: { index in
                inputViewModel.removeParticipant(at: IndexSet(integer: index))
            },
            onAdd: addParticipant,
            focusedId: $focusedId,
            scrollTarget: $scrollTarget,
            lastFocusedId: $lastFocusedId
        )
    }
}

// MARK: - Logic
private extension ParticipantInputListView {
    var canProceed: Bool {
        inputViewModel.validParticipantCount >= 3 && !inputViewModel.hasDuplicateNames
    }

    var alertMessage: String {
        if inputViewModel.validParticipantCount < 3 {
            return "참가자는 최소 3명 이상이어야 합니다."
        } else {
            return "중복된 이름이 존재합니다. 이름을 수정해주세요."
        }
    }

    func handlePlayTapped() {
        guard canProceed else {
            isAlertPresented = true
            return
        }

        roleViewModel.assignRoles(from: inputViewModel.tempParticipants)
        pathModel.push(.roleReveal(participants: roleViewModel.participants))
        
        print("✅ 제출된 유저: \(roleViewModel.participants.map { $0.name })")
    }

    func addParticipant() {
        inputViewModel.addParticipant()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let last = inputViewModel.tempParticipants.last {
                focusedId = last.id
                scrollTarget = last.id
            }
        }
    }

    func handleSubmit(index: Int, participant: Participant) {
        let trimmed = participant.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            inputViewModel.removeParticipant(at: IndexSet(integer: index))
        } else if let nextId = inputViewModel.nextParticipantId(after: participant.id) {
            focusedId = nextId
            scrollTarget = nextId
        }
    }
}

#Preview {
    ParticipantInputListView()
        .environmentObject(PathModel())
}
