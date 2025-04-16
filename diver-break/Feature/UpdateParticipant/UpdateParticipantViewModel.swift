//
//  UpdateParticipantViewModel.swift
//  diver-break
//
//  Created by J on 4/14/25.
//

import Foundation
import Combine

class UpdateParticipantViewModel: ObservableObject {
    // 기존 참가자 (수정 불가)
    let existingParticipants: [Participant]

    // 새로 입력하는 참가자
    @Published var newParticipants: [Participant] = []

    init(existingParticipants: [Participant]) {
        self.existingParticipants = existingParticipants
        self.newParticipants = [Participant()] // 기본 1칸 무조건
    }

    func nextParticipantId(after id: UUID) -> UUID? {
        guard let index = newParticipants.firstIndex(where: { $0.id == id }),
              index + 1 < newParticipants.count else {
            return nil
        }
        return newParticipants[index + 1].id
    }

    func addParticipant() {
        newParticipants.append(Participant())
    }

    func removeParticipant(at index: Int) {
        newParticipants.remove(at: index)
    }

    func isNameDuplicated(at index: Int) -> Bool {
        let name = newParticipants[index].name.trimmingCharacters(in: .whitespaces)

        guard !name.isEmpty else { return false } // 공백 또는 빈 문자열은 중복 검사에서 제외

        let count = newParticipants.filter { // 현재 입력 중인 참가자끼리 중복
            $0.name.trimmingCharacters(in: .whitespaces) == name
        }.count

        let isDuplicate = existingParticipants.contains { // 기존 참가자와도 중복 확인
            $0.name.trimmingCharacters(in: .whitespaces) == name
        }

        return count > 1 || isDuplicate
    }

    var hasDuplicateNames: Bool {
        let trimmedNames = newParticipants.map {
            $0.name.trimmingCharacters(in: .whitespaces)
        }.filter {
            !$0.isEmpty
        }

        let hasInternalDuplicates = Set(trimmedNames).count != trimmedNames.count

        let hasOverlapWithExisting = trimmedNames.contains { name in
            existingParticipants.contains {
                $0.name.trimmingCharacters(in: .whitespaces) == name
            }
        }

        return hasInternalDuplicates || hasOverlapWithExisting
    }
}
