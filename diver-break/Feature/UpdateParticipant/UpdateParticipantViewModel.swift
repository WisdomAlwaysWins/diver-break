//
//  UpdateParticipantViewModel.swift
//  diver-break
//
//  Created by J on 4/14/25.
//

import Foundation
import Combine

/*
    MARK: - 회의 중 참가자 추가 화면에서 사용되는 ViewModel
    - 기존 참가자(existingParticipants)는 수정 불가 (안됨 절대 안됨 노노)
    - 새로 입력하는 참가자(newParticipants)는 이름 중복 검사까지
*/

//class UpdateParticipantViewModel: ObservableObject {
//    
//    let existingParticipants: [Participant] // 기존 참가자 (수정 불가)
//    @Published var newParticipants: [Participant] = [] // 새로 입력하는 참가자
//
//    init(existingParticipants: [Participant]) { // 초기화 시, 빈 참가자 1명 추가 (text field를 위해)
//        self.existingParticipants = existingParticipants
//        self.newParticipants = [Participant()]
//    }
//
//    func nextParticipantId(after id: UUID) -> UUID? { // 포커스 이동
//        guard let index = newParticipants.firstIndex(where: { $0.id == id }),
//              index + 1 < newParticipants.count else {
//            return nil
//        }
//        return newParticipants[index + 1].id
//    }
//
//    func addParticipant() { // 참가자 추가
//        newParticipants.append(Participant())
//    }
//
//    func removeParticipant(at index: Int) { // 참가자 삭제
//        newParticipants.remove(at: index)
//    }
//
//    func isNameDuplicated(at index: Int) -> Bool { // 인덱스의 이름 중복 여부 확인 (새로 추가되고 있는 참가자 + 기존 참가자)
//        let name = newParticipants[index].name.trimmingCharacters(in: .whitespaces)
//
//        guard !name.isEmpty else { return false } // 공백 또는 빈 문자열은 중복 검사에서 제외
//
//        let count = newParticipants.filter { // 현재 입력 중인 참가자끼리 중복
//            $0.name.trimmingCharacters(in: .whitespaces) == name
//        }.count
//
//        let isDuplicate = existingParticipants.contains { // 기존 참가자와도 중복 확인
//            $0.name.trimmingCharacters(in: .whitespaces) == name
//        }
//
//        return count > 1 || isDuplicate
//    }
//
//    var hasDuplicateNames: Bool { // 전체 새로운 참가자에서 중복 이름이 존재하는지 여부
//        let trimmedNames = newParticipants.map {
//            $0.name.trimmingCharacters(in: .whitespaces)
//        }.filter {
//            !$0.isEmpty
//        }
//
//        let hasInternalDuplicates = Set(trimmedNames).count != trimmedNames.count
//
//        let hasOverlapWithExisting = trimmedNames.contains { name in
//            existingParticipants.contains {
//                $0.name.trimmingCharacters(in: .whitespaces) == name
//            }
//        }
//        return hasInternalDuplicates || hasOverlapWithExisting
//    }
//}
