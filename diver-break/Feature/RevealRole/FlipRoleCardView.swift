//
//  RevealRoleCardView.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import SwiftUI

struct FlipRoleCardView: View {
    let participant: Participant
    @Binding var isRevealed: Bool
    
    var body: some View {
        
        VStack {
            Spacer()
            
            ZStack {
                if isRevealed, let role = participant.assignedRole {
                    // 클릭 후 표정되는 뒤방
                    VStack {
                        Image(role.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width : UIScreen.main.bounds.width * 0.9)
                            .shadow(radius: 8)
                    }
                    
                } else {
                    // 클릭 전 앞면 (엎어진 카드)
                    ZStack {
                        Image("background")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                        
                        VStack(spacing: 24) {
                            Image("goggle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.25)
                            
                            Text(participant.name)
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .foregroundColor(.white)
                            
                            Text("2초간 누르면 역할이 공개됩니다")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
//                    .background(.red)
                    .onLongPressGesture(minimumDuration: 2.0) {
                        print("PRESS")
                        withAnimation {
                            isRevealed = true
                        }
                    }
                }
            }
            //        .background(.blue)
            
            Spacer()
        }
        .frame(maxHeight: UIScreen.main.bounds.height * 0.7)
    }
}

#Preview {
    @State var revealed = false
    
    return FlipRoleCardView(
        participant: Participant(
            name: "지혜",
            assignedRole: Role(
                name: "에너지 체커",
                description: "다이버의 에너지를 확인하고 당보충 아이디어를 제공합니다.",
                guide: "에너지 레벨 물어보기, “간식 타임?” 물어보기",
                imageName: "energychecker3d"
            )
        ),
        isRevealed: $revealed
    )
}
