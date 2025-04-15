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
    @Binding var participants: [Participant]
    let isDuplicate: (Int) -> Bool
    let onSubmit: (Int, Participant) -> Void
    let onDelete: (Int) -> Void
    let onAdd: () -> Void
    let focusedId: FocusState<UUID?>.Binding
    let scrollTarget: Binding<UUID?>
    let lastFocusedId: Binding<UUID?>

    var body: some View {
        ScrollViewReader { proxy in
            List {
                Section(header: participantCountHeader) {
                    ForEach(Array(zip(participants.indices, $participants)), id: \.1.id) { index, $participant in
                        ParticipantCellView(
                            participant: $participant,
                            index: index,
                            isDuplicate: isDuplicate(index),
                            onSubmit: {
                                onSubmit(index, participant)
                            },
                            onDelete: {
                                onDelete(index)
                            },
                            focusedId: focusedId
                        )
                        .id(participant.id)
                        .focused(focusedId, equals: participant.id)
                        .listRowBackground(Color.clear)
                    }

                    Button(action: onAdd) {
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
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .padding(.horizontal, 20)
            .onChange(of: scrollTarget.wrappedValue) { id in
                if let id = id {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .center)
                    }
                }
            }
            .onChange(of: focusedId.wrappedValue) { newValue in
                if newValue == nil, let lastId = lastFocusedId.wrappedValue {
                    if let index = participants.firstIndex(where: { $0.id == lastId }),
                       participants[index].trimmedName.isEmpty {
                        onDelete(index)
                    }
                }
                lastFocusedId.wrappedValue = newValue
            }
        }
    }

    private var participantCountHeader: some View {
        HStack {
            Spacer()
            Text("현재 \(participants.filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }.count)명 참여")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.diverBlack)
                .padding(.vertical, 4)
        }
    }
}

#Preview {
    struct ParticipantListViewPreviewWrapper: View {
        @State private var participants: [Participant] = [
            Participant(name: "제이"),
            Participant(name: "체리"),
            Participant(name: "지지")
        ]

        @FocusState private var focusedId: UUID?
        @State private var scrollTarget: UUID?
        @State private var lastFocusedId: UUID?

        var body: some View {
            ParticipantListView(
                participants: $participants,
                isDuplicate: { index in
                    let name = participants[index].trimmedName
                    guard !name.isEmpty else { return false }
                    return participants.filter { $0.trimmedName == name }.count > 1
                },
                onSubmit: { index, participant in
                    let trimmed = participant.name.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.isEmpty {
                        participants.remove(at: index)
                    } else if index + 1 < participants.count {
                        focusedId = participants[index + 1].id
                        scrollTarget = participants[index + 1].id
                    }
                },
                onDelete: { index in
                    participants.remove(at: index)
                },
                onAdd: {
                    let new = Participant()
                    participants.append(new)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        focusedId = new.id
                        scrollTarget = new.id
                    }
                },
                focusedId: $focusedId,
                scrollTarget: $scrollTarget,
                lastFocusedId: $lastFocusedId
            )
        }
    }

    return ParticipantListViewPreviewWrapper()
}
