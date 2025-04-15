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
    
    @ObservedObject var participantViewModel: ParticipantViewModel
    
    var focusedId: FocusState<UUID?>.Binding // 포커스 상태 바인딩 (각 셀의 TextField 포커스 관리용)
    var onSubmit: (Int, Participant) -> Void

    var body: some View {
        ForEach(Array(participantViewModel.participants.enumerated()), id: \.1.id) { index, participant in
            ParticipantCellView(
                participantViewModel: participantViewModel,
                index: index,
                onSubmit: {
                    onSubmit(index, participantViewModel.participants[index])
                },
                focusedId: focusedId,
                id: participant.id
            )
            .id(participant.id)
            .listRowBackground(Color.clear)
        }
    }
}

#Preview {
    struct ParticipantListSectionPreviewWrapper: View {
        @StateObject private var viewModel = ParticipantViewModel(
            participants: [
                Participant(name: "HappyJay"),
                Participant(name: "Gigi"),
                Participant(name: "Moo")
            ],
            mode: .input
        )

        @FocusState private var focusedId: UUID?

        var body: some View {
            List {
                ParticipantListSectionView(
                    participantViewModel: viewModel,
                    focusedId: $focusedId,
                    onSubmit: { index, participant in
                        print("✅ Submitted: \(participant.name) at index \(index)")
                    }
                )
            }
            .listStyle(.plain)
        }
    }

    return ParticipantListSectionPreviewWrapper()
}
