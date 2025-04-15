//
//  ㅖ
//  diver-break
//
//  Created by J on 4/12/25.
//

import SwiftUI

/*
    MARK: - 참가자 이름을 입력받는 화면
    - 최소 3명 이상의 입력, 중복 이름 불가, 이름 입력 후 역할 랜덤 배정
    - Custom Navbar, ParticipantListView 포함
*/

struct ParticipantInputListView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject private var participantViewModel = ParticipantViewModel(mode: .input)
    @StateObject private var roleViewModel = RoleAssignmentViewModel()

    @FocusState private var focusedId: UUID?
    @State private var lastFocusedId: UUID?
    @State private var scrollTarget: UUID?
    @State private var isAlertPresented = false
    @State private var validationResult: SubmissionValidationResult? = nil

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
        .navigationBarHidden(true)
    }
}

// MARK: - View
private extension ParticipantInputListView {
    var backgroundView: some View {
        Color(.systemBackground)
            .ignoresSafeArea()
            .onTapGesture { // tap 누르면 키보드 내리기
                focusedId = nil
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }

    // 네비게이션 바 + 안내문 + 입력 리스트
    var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            navigationBar
            headerArea
                .padding(.horizontal)
                .padding(.top, 20)
            participantList
        }
    }

    // 커스텀 네브바 (도움말 / 시작하기)
    var navigationBar: some View {
        CustomNavigationBar(
            isDisplayLeftBtn: true,
            isDisplayRightBtn: true,
            leftBtnAction: { print("도움말 눌림") },
            rightBtnAction: handlePlayTapped,
            leftBtnType: nil,
            rightBtnType: .play,
            rightBtnColor: participantViewModel.validateSubmission() == .valid ? .diverBlue : .diverIconGray
        )
    }

    // 타이틀 및 안내 텍스트
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
    
    // List 기반 입력 영역
    var participantList: some View {
        ParticipantListView(
            participants: $participantViewModel.participants,
            isDuplicate: { participantViewModel.isNameDuplicated(at: $0) },
            onSubmit: handleSubmit,
            onDelete: participantViewModel.removeParticipant,
            onAdd: addParticipant,
            focusedId: $focusedId,
            scrollTarget: $scrollTarget,
            lastFocusedId: $lastFocusedId
        )
    }
}

// MARK: - Logic
private extension ParticipantInputListView {
    var alertMessage: String {
        switch validationResult {
        case .notEnough:
            return "참가자는 최소 3명 이상이어야 합니다."
        case .duplicated:
            return "중복된 이름이 존재합니다. 이름을 수정해주세요."
        default:
            return ""
        }
    }

    func handlePlayTapped() { // 시작 버튼의 액션
        switch participantViewModel.validateSubmission() {
        case .valid:
            roleViewModel.assignRoles(from: participantViewModel.participants)
            pathModel.push(.roleReveal(participants: roleViewModel.participants))
        case .notEnough, .duplicated:
            validationResult = participantViewModel.validateSubmission()
        }
        
        print("✅ 제출된 유저: \(roleViewModel.participants.map { $0.name })") // TEST
    }

    func addParticipant() { // 새로운 참가자 추가 및 자동 포커스
        participantViewModel.addParticipant()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // TODO: - ?
            if let last = participantViewModel.participants.last {
                focusedId = last.id
                scrollTarget = last.id
            }
        }
    }

    func handleSubmit(index: Int, participant: Participant) { // 입력 완료 시 비어있으면 삭제, 다음 셀로 포커스 이동
        let trimmed = participant.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            participantViewModel.removeParticipant(at: index)
        } else if let nextId = participantViewModel.nextId(after: participant.id) {
            focusedId = nextId
            scrollTarget = nextId
        }
    }
}

#Preview {
    ParticipantInputListView()
        .environmentObject(PathModel())
}
