//
//  ParticipantListView.swift
//  diver-break
//
//  Created by J on 4/14/25.
//

import SwiftUI

struct ParticipantListView: View {
    @Binding var participants: [Participant]
    var isDuplicate: (Int) -> Bool
    var onSubmit: (Int, Participant) -> Void
    var onDelete: (Int) -> Void
    var onAdd: () -> Void

    var focusedId: FocusState<UUID?>.Binding
    @Binding var scrollTarget: UUID?
    @Binding var lastFocusedId: UUID?

    var body: some View {
        ScrollViewReader { proxy in
            List {
                Section(header: participantCountHeader) {
                    ParticipantListSectionView(
                        participants: $participants,
                        focusedId: focusedId,
                        isDuplicate: isDuplicate,
                        onSubmit: onSubmit,
                        onDelete: onDelete
                    )

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
            .onChange(of: scrollTarget) { id in
                if let id = id {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .center)
                    }
                }
            }
            .onChange(of: focusedId.wrappedValue) { newValue in
                if newValue == nil, let lastId = lastFocusedId {
                    participants.removeAll {
                        $0.id == lastId && $0.name.trimmingCharacters(in: .whitespaces).isEmpty
                    }
                }
                lastFocusedId = newValue
            }
        }
    }

    private var participantCountHeader: some View {
        HStack {
            Spacer()
            Text("현재 \(validParticipantCount)명 참여")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.diverBlack)
                .padding(.vertical, 4)
        }
    }

    private var validParticipantCount: Int {
        participants.filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }.count
    }
}

#Preview {
//    ParticipantListView()
    ParticipantListViewPreviewWrapper()
}

struct ParticipantListViewPreviewWrapper: View {
    @State private var participants: [Participant] = [
        Participant(name: "HappyJay"),
        Participant(name: "Gigi"),
        Participant(name: "Moo")
    ]

    @FocusState private var focusedId: UUID?
    @State private var scrollTarget: UUID? = nil
    @State private var lastFocusedId: UUID? = nil

    var body: some View {
        ParticipantListView(
            participants: $participants,
            isDuplicate: { _ in false },
            onSubmit: { index, participant in
                print("✅ Submitted: \(participant.name) at index \(index)")
            },
            onDelete: { index in
                participants.remove(at: index)
            },
            onAdd: {
                let new = Participant(name: "")
                participants.append(new)
                scrollTarget = new.id
                focusedId = new.id
            },
            focusedId: $focusedId,
            scrollTarget: $scrollTarget,
            lastFocusedId: $lastFocusedId
        )
    }
}
