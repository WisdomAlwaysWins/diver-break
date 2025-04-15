//
//  CheckMyCardView.swift
//  diver-break
//
//  Created by J on 4/15/25.
//

import SwiftUI

/*
    MARK: - 참가자의 역할 카드를 보여주는 개별 카드 뷰
    - 길게 누르면 역할 정보가 표시됨
    - 공개 중인 카드 상태는 relveadId로 관리
*/

struct CheckMyCardView : View {
    let participant: Participant // 지금 카드의 참가자 정보
    
    @Binding var revealedId: UUID? // 현재 공개된 카드 ID (하나만 공개되도록!)

    var body: some View {
        let isRevealing = revealedId == participant.id // 지금 이 참가자의 카드가 공개 상태인지 체크

        VStack(alignment: .leading, spacing: 8) {
            Text(participant.name)
                .font(.headline)

            if isRevealing, let role = participant.assignedRole { // 공개되어있으면 역할을 표시
                Text(role.name)
                    .font(.subheadline)
                    .foregroundColor(.diverBlue)

                Text(role.guide)
                    .font(.caption)
                    .foregroundColor(.diverGray2)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .aspectRatio(1, contentMode: .fit)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.diverGray0, lineWidth: 1)
        )
        .onLongPressGesture(minimumDuration: 2.0, pressing: { isPressing in
            if isPressing {
                revealedId = participant.id // 길게 누르는 중 -> 공개
            } else {
                // 손 뗄 때 -> 숨김
                if revealedId == participant.id {
                    revealedId = nil
                }
            }
        }, perform: { })
    }
}



#Preview {
    struct CheckMyCardViewPreviewWrapper: View {
        @State private var revealedId: UUID? = nil

        var body: some View {
            CheckMyCardView(
                participant: Participant(
                    name: "지혜",
                    assignedRole: Role(
                        name: "에너지 체커",
                        description: "다이버의 에너지를 확인하고 당보충 아이디어를 제공합니다.",
                        guide: "에너지 레벨 물어보기, “간식 타임?” 물어보기",
                        imageName: "energychecker3d"
                    )
                ),
                revealedId: $revealedId
            )
            .padding()
            .background(Color.diverBackgroundBlue)
        }
    }

    return CheckMyCardViewPreviewWrapper()
}
