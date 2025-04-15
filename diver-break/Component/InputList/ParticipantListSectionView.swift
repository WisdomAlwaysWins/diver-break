//
//  ParticipantListSectionView.swift
//  diver-break
//
//  Created by J on 4/14/25.
//

import SwiftUI

/*
    MARK: - 참가자 리스트의 섹션을 구성하는 뷰
    - 각 참가자 항목은 ParticipantCellView로 구성함
    - 포커스, 중복 체크, 삭제, 제출 등의 기능은 외부에서 주입받아 처리
*/

struct ParticipantListSectionView: View {
    @Binding var participants: [Participant]
    var isDuplicate: (Int) -> Bool
    var onSubmit: (Int, Participant) -> Void
    var onDelete: (Int) -> Void

    var focusedId: FocusState<UUID?>.Binding

    var body: some View {
        ForEach($participants.indices, id: \.self) { index in
            ParticipantCellView(
                participant: $participants[index],
                index: index,
                isDuplicate: isDuplicate(index),
                onSubmit: {
                    onSubmit(index, participants[index])
                },
                onDelete: {
                    onDelete(index)
                },
                focusedId: focusedId
            )
            .id(participants[index].id)
            .listRowBackground(Color.clear)
        }
    }
}

#Preview {
    struct ParticipantListSectionPreviewWrapper: View {
        @State private var participants: [Participant] = [
            Participant(name: "HappyJay"),
            Participant(name: "Gigi"),
            Participant(name: "Moo")
        ]
        @FocusState private var focusedId: UUID?

        var body: some View {
            List {
                ParticipantListSectionView(
                    participants: $participants,
                    isDuplicate: { index in
                        let name = participants[index].trimmedName
                        guard !name.isEmpty else { return false }
                        return participants.filter { $0.trimmedName == name }.count > 1
                    },
                    onSubmit: { index, participant in
                        print("✅ Submitted: \(participant.name) at index \(index)")
                    },
                    onDelete: { index in
                        participants.remove(at: index)
                    },
                    focusedId: $focusedId
                )
            }
        }
    }

    return ParticipantListSectionPreviewWrapper()
}
