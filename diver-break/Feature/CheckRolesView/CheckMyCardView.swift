//
//  CheckMyCardView.swift
//  diver-break
//
//  Created by J on 4/15/25.
//

import SwiftUI

struct CheckMyCardView : View {
    let participant: Participant
    @Binding var revealedId: UUID?

    var body: some View {
        let isRevealing = revealedId == participant.id

        VStack(alignment: .leading, spacing: 8) {
            Text(participant.name)
                .font(.headline)

            if isRevealing, let role = participant.assignedRole {
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
        .onLongPressGesture(minimumDuration: 4.0, pressing: { isPressing in
            if isPressing {
                revealedId = participant.id
            } else {
                // 손 뗄 때만 초기화
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
