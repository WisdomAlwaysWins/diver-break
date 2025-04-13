//
//  ParticipantCellView.swift
//  diver-break
//
//  Created by J on 4/13/25.
//

import SwiftUI

// MARK: - 참가자 입력 셀
struct ParticipantCellView: View {
    @Binding var participant: Participant
    let index: Int
    let isDuplicate: Bool
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 12) {
                TextField("이름을 입력하세요.", text: $participant.name)
                    .submitLabel(.next)
                    .padding(.vertical, 4)
                    .foregroundColor(isDuplicate ? .red : .primary)

                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.diverGray2)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }

            if isDuplicate {
                Text("중복된 이름이에요!")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    @State var sample = Participant(name: "HappyJay")

    return ParticipantCellView(
        participant: $sample,
        index: 0,
        isDuplicate: false,
        onDelete: {}
    )
}
