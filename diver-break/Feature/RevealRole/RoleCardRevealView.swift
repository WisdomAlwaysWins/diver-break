//
//  RoleRevealView.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import SwiftUI

struct RoleCardRevealView: View {
    let participants: [Participant] // 역할 배정된 참가자 리스트

    @State private var currentIndex = 0
    @State private var isRevealed = false
    @State private var navigateToNext = false

    var body: some View {
        let participant = participants[currentIndex]

        ZStack {
            Image("ocean")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 24) {
//                Spacer()
                
                FlipRoleCardView(
                    participant: participant,
                    isRevealed: $isRevealed
                )
                
                buttonArea
                
                Spacer()
            }
            .padding()
            
            NavigationLink(destination: Text("진짜 홈화면"), isActive: $navigateToNext) {
                EmptyView()
            }
            .hidden()
            
            
        }
//        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private var buttonArea: some View {
        if isRevealed {
            if currentIndex < participants.count - 1 {
                Button("다음 사람") {
                    handleNextParticipant()
                }
                .font(.headline)
                .frame(maxWidth: 300)
                .padding(.vertical, 20)
                .background(Color.diverWhite)
                .foregroundColor(.diverBlack)
                .cornerRadius(40)
            } else {
                Button("모두 확인했어요") {
                    handleCompleteReveal()
                }
                .font(.headline)
                .frame(maxWidth: 300)
                .padding(.vertical, 20)
                .background(Color.diverWhite)
                .foregroundColor(.diverBlack)
                .cornerRadius(40)
            }
        } else {
            Color.clear
                .frame(height: 56)
                .padding(.horizontal, 40)
        }
    }
    
    
}

extension RoleCardRevealView {
    private func handleNextParticipant() {
        withAnimation {
            currentIndex += 1
            isRevealed = false
        }
    }

    private func handleCompleteReveal() {
        withAnimation {
            navigateToNext = true
        }
    }
}

#Preview {
    RoleCardRevealViewPreviewWrapper()
}

struct RoleCardRevealViewPreviewWrapper: View {
    @State private var revealed = false

    var body: some View {
        RoleCardRevealView(participants: [
            Participant(
                name: "지혜",
                assignedRole: Role(
                    name: "에너지 체커",
                    description: "다이버의 에너지를 확인하고 당보충 아이디어를 제공합니다.",
                    guide: "에너지 레벨 물어보기, “간식 타임?” 물어보기",
                    imageName: "energychecker3d"
                )
            ),
            Participant(
                name: "준호",
                assignedRole: Role(
                    name: "거북목 보안관",
                    description: "거북목 같은 디스크를 예방하고 다이버를 보호합니다.",
                    guide: "손목 / 목 스트레칭하기 또는 눈 감고 휴식하기",
                    imageName: "discguardian3d"
                )
            )
        ])
    }
}

