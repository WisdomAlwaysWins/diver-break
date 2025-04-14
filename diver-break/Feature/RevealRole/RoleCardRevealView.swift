//
//  RoleRevealView.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import SwiftUI

// MARK: - 역할 카드 공개 뷰
struct RoleCardRevealView: View {
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var roleViewModel: RoleAssignmentViewModel
    
    let participants: [Participant]
    
    @State private var currentIndex = 0
    @State private var isRevealed = false
    
    var body: some View {
        ZStack {
            // 바다 배경
            background
            
            if participants.indices.contains(currentIndex) {
                content
            } else {
                errorMessage
            }
        }
        .onAppear(perform: printParticipants)
    }
    
    var navigationBar: some View {
        CustomNavigationBar(
            isDisplayLeftBtn: true,
            isDisplayRightBtn: true,
            leftBtnAction: { print("도움말 눌림") },
            leftBtnType: .back,
            rightBtnType: nil
            //            rightBtnColor: canProceed ? .diverBlue : .diverIconGray
        )
    }
}

// MARK: - View 구성
private extension RoleCardRevealView {
    var background: some View {
        Image("ocean")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    var content: some View {
        let participant = participants[currentIndex]
        
        return VStack {
            Spacer()
            
            FlipRoleCardView(
                participant: participant,
                isRevealed: $isRevealed
            )
            .padding(.bottom, 20)
            
            buttonArea
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    var errorMessage: some View {
        VStack(spacing: 16) {
            Text("😵 역할 정보를 불러올 수 없어요.")
                .font(.headline)
                .foregroundColor(.red)
        }
    }
    
    @ViewBuilder
    var buttonArea: some View {
        let action: () -> Void = currentIndex < participants.count - 1 ? handleNextParticipant : handleCompleteReveal
        
        if isRevealed {
            Button(action: action) {
                Text("확인")
                    .font(.headline)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 20)
                    .background(Color.diverWhite)
                    .foregroundColor(Color.diverBlack)
                    .cornerRadius(40)
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
        } else {
            Color.clear
                .frame(height: 56)
                .padding(.horizontal, 40)
        }
    }
}

// MARK: - 로직
private extension RoleCardRevealView {
    func handleNextParticipant() {
        withAnimation {
            currentIndex += 1
            isRevealed = false
        }
    }
    
    func handleCompleteReveal() {
        withAnimation {
            roleViewModel.participants = participants // ✅ participants 저장
            roleViewModel.isJokerRevealed = false
            pathModel.push(.main)
        }
    }
    
    func printParticipants() {
        print("🧭 RoleCardRevealView로 전달된 participants 수: \(participants.count)")
        participants.forEach { participant in
            print(" - \(participant.name), 역할: \(participant.assignedRole?.name ?? "없음")")
        }
    }
}

// MARK: - 미리보기
#Preview {
    RoleCardRevealViewPreviewWrapper()
        .environmentObject(PathModel())
        .environmentObject(RoleAssignmentViewModel())
}

struct RoleCardRevealViewPreviewWrapper: View {
    var body: some View {
        RoleCardRevealView(participants: [
            Participant(
                name: "HappyJay",
                assignedRole: Role(
                    name: "에너지 체커",
                    description: "다이버의 에너지를 확인하고 당보충 아이디어를 제공합니다.",
                    guide: "에너지 레벨 물어보기, “간식 타임?” 물어보기",
                    imageName: "energychecker3d"
                )
            ),
            Participant(
                name: "Gigi",
                assignedRole: Role(
                    name: "거북목 보안관",
                    description: "거북목 같은 디스크를 예방하고 다이버를 보호합니다.",
                    guide: "손목 / 목 스트레칭하기 또는 눈 감고 휴식하기",
                    imageName: "discguardian3d"
                )
            )
        ])
        .environmentObject(PathModel())
    }
}
