//
//  ParticipantListSectionView.swift
//  diver-break
//
//  Created by J on 4/14/25.
//

import SwiftUI

struct ParticipantListSectionView: View {
    @Binding var participants: [Participant]
    var focusedId: FocusState<UUID?>.Binding
    var isDuplicate: (Int) -> Bool
    var onSubmit: (Int, Participant) -> Void
    var onDelete: (Int) -> Void

    var body: some View {
        ForEach(Array(zip(participants.indices, $participants)), id: \.1.id) { index, $participant in
            ParticipantCellView(
                participant: $participant,
                index: index,
                isDuplicate: isDuplicate(index),
                onDelete: {
                    onDelete(index)
                }
            )
            .id(participant.id)
            .focused(focusedId, equals: participant.id)
            .onSubmit {
                onSubmit(index, participant)
            }
            .listRowBackground(Color.clear)
        }
    }
}

#Preview {
    ParticipantListPreviewWrapper()
}

struct ParticipantListPreviewWrapper: View {
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
                focusedId: $focusedId,
                isDuplicate: { _ in false }, // 여기선 중복 체크 생략
                onSubmit: { index, participant in
                    print("✅ Submitted: \(participant.name) at \(index)")
                },
                onDelete: { index in
                    participants.remove(at: index)
                }
            )
        }
        .listStyle(.plain)
    }
}
