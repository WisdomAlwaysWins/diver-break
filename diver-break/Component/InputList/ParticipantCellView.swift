//
//  ParticipantCellView.swift
//  diver-break
//
//  Created by J on 4/13/25.
//

import SwiftUI

/*
    MARK: - 참가자 입력 셀
    - 이름을 입력받는 텍스트 필드와 삭제 버튼이 포함된 셀
    - 중복 이름이 있으면 경고 메시지
    - 삭제 버튼을 누르면 삭제
*/

struct ParticipantCellView: View {
    @Binding var participant: Participant
    let index: Int
    let isDuplicate: Bool
    let onSubmit: () -> Void
    let onDelete: () -> Void
    let focusedId: FocusState<UUID?>.Binding

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 12) {
                TextField("이름을 입력하세요.", text: $participant.name)
                    .submitLabel(.next)
                    .padding(.vertical, 4)
                    .foregroundColor(isDuplicate ? .red : .primary)
                    .focused(focusedId, equals: participant.id)
                    .onSubmit(onSubmit)

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

//struct ParticipantCellView: View {
//
//    @ObservedObject var participantViewModel : ParticipantViewModel
//    
//    let index : Int
//    let onSubmit : () -> Void
//    let focusedId : FocusState<UUID?>.Binding
//    let id : UUID
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            HStack(spacing: 12) {
//                TextField("이름을 입력하세요.",
//                    text: Binding(
//                        get: {
//                            guard participantViewModel.participants.indices.contains(index) else { return "" }
//                            return participantViewModel.participants[index].name
//                        },
//                        set: {
//                            guard participantViewModel.participants.indices.contains(index) else { return }
//                            participantViewModel.participants[index].name = $0
//                        }
//                    )
//                )
//                .submitLabel(.next)
//                .padding(.vertical, 4)
//                .foregroundColor(participantViewModel.isNameDuplicated(at: index) ? .red : .primary)
//                .focused(focusedId, equals: id)
//                .onSubmit(onSubmit)
//
//                Button(action: { participantViewModel.removeParticipant(at: index) }) { // 삭제 버튼
//                    Image(systemName: "xmark.circle.fill")
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                        .foregroundColor(.diverGray2)
//                        .contentShape(Rectangle()) // 터치 영역 확장
//                }
//                .buttonStyle(PlainButtonStyle()) // 버튼 기본 효과 제거
//            }
//
//            if participantViewModel.isNameDuplicated(at: index) { // 중복 경고 메시지
//                Text("중복된 이름이에요!")
//                    .font(.caption)
//                    .foregroundColor(.red)
//            }
//        }
//    }
//}

#Preview {
    struct ParticipantCellViewPreviewWrapper: View {
        @State private var participant = Participant(name: "지혜")
        @FocusState private var focusedId: UUID?

        var body: some View {
            ParticipantCellView(
                participant: $participant,
                index: 0,
                isDuplicate: true, // 테스트용 중복 상태
                onSubmit: {
                    print("✅ Submitted: \(participant.name)")
                },
                onDelete: {
                    print("❌ 삭제됨")
                },
                focusedId: $focusedId
            )
            .padding()
        }
    }

    return ParticipantCellViewPreviewWrapper()
}
