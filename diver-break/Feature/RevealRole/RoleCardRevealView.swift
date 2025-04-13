//
//  RoleRevealView.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import SwiftUI

struct RoleCardRevealView: View {
    @EnvironmentObject var pathModel : PathModel
    
    let participants: [Participant] // 역할 배정된 참가자 리스트

    @State private var currentIndex = 0
    @State private var isRevealed = false
    @State private var navigateToNext = false

    var body: some View {

        ZStack {
            Image("ocean")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            if participants.indices.contains(currentIndex) {
                let participant = participants[currentIndex]
                
                VStack(spacing: 24) {
                    
                    FlipRoleCardView(
                        participant: participant,
                        isRevealed: $isRevealed
                    )
                    
                    buttonArea
                    
                    Spacer()
                }
                .padding()
            } else {
                VStack(spacing: 16) {
                    Text("😵 역할 정보를 불러올 수 없어요.")
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            print("🧭 RoleCardRevealView로 전달된 participants 수: \(participants.count)")
            participants.forEach { participant in
                print(" - \(participant.name), 역할: \(participant.assignedRole?.name ?? "없음")")
            }
        }
    }
    
    @ViewBuilder
    private var buttonArea: some View {
        
        let action : () -> Void = currentIndex < participants.count - 1 ? handleNextParticipant : handleCompleteReveal
        
        if isRevealed {
            Button(action : action) {
                Text("확인")
                    .font(.headline)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 20)
                    .background(Color.diverWhite)
                    .foregroundColor(.diverBlack)
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

extension RoleCardRevealView {
    private func handleNextParticipant() {
        withAnimation {
            currentIndex += 1
            isRevealed = false
        }
    }

    private func handleCompleteReveal() {
        withAnimation {
            pathModel.push(.main)
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

