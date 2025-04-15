//
//  AddNicknameViewModel.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import Foundation
import SwiftUI

/*
    MARK: - 참가자 입력 화면에서 사용되는 ViewModel
    - 참가자 임시 배열 관리 -> submit 해야 최종 저장
    - 최소 3명 보장, 중복 이름 검출, 자동 포커스 이동 가능
*/

enum SubmissionValidationResult { // submit validation 검사
    case valid
    case notEnough
    case duplicated
}

class ParticipantViewModel : ObservableObject {
    
    enum Mode {
        case input // 최소 3명 유지
        case update // 최소 1명 유지
    }
    
    private var mode : Mode
    
    @Published var participants : [Participant]
    var existingParticipants : [Participant]
    
    init(participants: [Participant] = [], existingParticipants: [Participant] = [] , mode: Mode = .input) {
        
        if participants.isEmpty {
            let minimum = mode == .input ? 3 : 1
            self.participants = (0..<minimum).map { _ in Participant() }
        } else {
            self.participants = participants
        }
        self.existingParticipants = existingParticipants
        self.mode = mode
    }
    
    var existingNames : Set<String> { // 기존 참가자 이름 set
        Set(existingParticipants.map { $0.name.trimmingCharacters(in: .whitespaces)})
    }
    
    // 빈 참가자 추가
    func addParticipant() { // p, u
        withAnimation {
            participants.append(Participant())
        }
    }
    
    func addParticipantAndReturn() -> Participant {
        let new = Participant()
        withAnimation {
            participants.append(new)
        }
        return new
    }
    
    // 참가자 삭제 (모드에 따라 최소 셀 유지)
    func removeParticipant(at index : Int) {
        withAnimation {
            participants.remove(at: index)
            ensureMinimumCount()
        }
    }
    
    private func ensureMinimumCount() {
        let miminum = mode == .input ? 3 : 1
        while participants.count < miminum {
            participants.append(Participant())
        }
    }
    
    func nextId(after id: UUID) -> UUID? {
        guard let index = participants.firstIndex(where: { $0.id == id }),
              index + 1 < participants.count else {
            return nil
        }
        return participants[index + 1].id
    }
    
    func removeIfEmpty(id: UUID) {
        if let index = participants.firstIndex(where: { $0.id == id }),
           !participants[index].isValid {
            removeParticipant(at: index)
        }
    }
    
    func isNameDuplicated(at index: Int) -> Bool {
        let name = participants[index].trimmedName
        guard !name.isEmpty else { return false }

        let count = participants.filter { $0.trimmedName == name }.count
        return count > 1 || existingNames.contains(name)
    }
    
    var hasDuplicateNames: Bool {
        let trimmed = participants.map { $0.trimmedName }.filter { !$0.isEmpty }
        return Set(trimmed).count != trimmed.count || trimmed.contains { existingNames.contains($0) }
    }

    var validParticipantCount: Int {
        participants.filter { $0.isValid }.count
    }

    func roleForExistingParticipant(named name: String) -> Role? {
        existingParticipants.first { $0.trimmedName == name }?.assignedRole
    }

    func submitParticipant(index: Int, id: UUID, onNext: (UUID?) -> Void) {
        if !participants[index].isValid {
            removeParticipant(at: index)
            onNext(nil)
        } else {
            onNext(nextId(after: id))
        }
    }

    func validateSubmission() -> SubmissionValidationResult {
        let trimmed = participants.map { $0.trimmedName }.filter { !$0.isEmpty }
        let isValidCount = mode == .input ? trimmed.count >= 3 : trimmed.count >= 1
        let hasDuplicatesInNew = Set(trimmed).count != trimmed.count
        let hasDuplicatesInExisting = !existingNames.isDisjoint(with: trimmed) // TODO: - isDisjoint ?
        
        if !isValidCount {
            return .notEnough
        } else if hasDuplicatesInNew || (mode == .update && hasDuplicatesInExisting) {
            return .duplicated
        } else {
            return .valid
        }
    }
    
}
