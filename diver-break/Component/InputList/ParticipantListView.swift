//
//  ParticipantListView.swift
//  diver-break
//
//  Created by J on 4/14/25.
//

import SwiftUI

/*
    MARK: - 참가자 목록 전체를 보여주는 리스트 뷰
    - 리스트 섹션 + 새 참가자 추가 버튼
    - 포커스 관리, 자동 스크롤, 입력된 닉네임 삭제 로직 등을 포함
*/

struct ParticipantListView: View {
    
    @ObservedObject var participantViewModel : ParticipantViewModel

    var focusedId: FocusState<UUID?>.Binding // 스크롤 상태 관리
    @Binding var scrollTarget: UUID? // 자동 스크롤 대상 ID
    @Binding var lastFocusedId: UUID? // 마지막 포커스 ID (포커스 해제 후 비어있는 셀 정리용)

    var body: some View {
        ScrollViewReader { proxy in // 내부 스크롤 뷰의 각 항목을 고유 ID로 식별하고, 해당 ID를 기반으로 스크롤할 수 있게 해줌
            List {
                Section(header: participantCountHeader) {
                    ParticipantListSectionView( // 참가자 리스트 섹션
                        participantViewModel: participantViewModel,
                        focusedId: focusedId,
                        onSubmit: { index, participant in
                            participantViewModel.submitParticipant(index: index, id: participant.id) { nextId in
                                focusedId.wrappedValue = nextId
                                scrollTarget = nextId
                            }
                        }
                    )

                    Button(action: {
                        let new = participantViewModel.addParticipantAndReturn()
                        scrollTarget = new.id
                        focusedId.wrappedValue = new.id
                    }) { // 참가자 추가 버튼
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.diverBlue)
                            Text("새로운 이름")
                                .foregroundColor(.diverBlue)
                                .fontWeight(.bold)
                        }
                        .font(.headline)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden) // 리스트 배경 제거
            .background(Color.clear)
            .padding(.horizontal, 20)
            .onChange(of: scrollTarget) { id in // 참가자 추가 시 자동 스크롤
                if let id = id {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .bottom) 
                    }
                }
            }
            .onChange(of: focusedId.wrappedValue) { newValue in // 포커스 해제 시 비어있는 셀 삭제
                if newValue == nil, let lastId = lastFocusedId {
                    participantViewModel.removeIfEmpty(id: lastId)
                }
                lastFocusedId = newValue
            }
        }
    }

    // MARK: - 참가자 수 헤더
    private var participantCountHeader: some View {
        HStack {
            HStack(spacing: 0) {
                Text("현재")
                Text(" \(participantViewModel.validParticipantCount)")
                    .foregroundColor(.diverBlue)
                Text("명 참여")
            }
            Spacer()
        }.font(.subheadline)
            .fontWeight(.medium)
            .padding(.vertical, 4)
    }
}

#Preview {
    struct ParticipantListViewPreviewWrapper: View {
        @StateObject private var viewModel = ParticipantViewModel(
            participants: [
                Participant(name: "HappyJay"),
                Participant(name: "Gigi"),
                Participant(name: "Moo")
            ],
            mode: .input
        )

        @FocusState private var focusedId: UUID?
        @State private var scrollTarget: UUID? = nil
        @State private var lastFocusedId: UUID? = nil

        var body: some View {
            ParticipantListView(
                participantViewModel: viewModel,
                focusedId: $focusedId,
                scrollTarget: $scrollTarget,
                lastFocusedId: $lastFocusedId
            )
        }
    }

    return ParticipantListViewPreviewWrapper()
}
