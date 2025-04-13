//
//  AddNicknameViewModel.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import Foundation
import SwiftUI

class ParticipantViewModel: ObservableObject {
    @Published var participants: [Participant] = [
        Participant(name: ""),
        Participant(name: ""),
        Participant(name: "")
    ]

    @Published var submittedUsers: [Participant] = []

    var validParticipantCount: Int {
        participants.filter {
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }.count
    }

    func addParticipant() {
        withAnimation {
            participants.append(Participant(name: ""))
        }
    }

    func removeParticipant(at offsets: IndexSet) {
        withAnimation {
            participants.remove(atOffsets: offsets)
            while participants.count < 3 {
                participants.append(Participant(name: ""))
            }
        }
    }

    func createRealUsers() {
        submittedUsers = participants.filter {
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        print("\u{2705} 제출된 유저들: \(submittedUsers.map { $0.name })")
    }

    func nextParticipantId(after id: UUID) -> UUID? {
        if let currentIndex = participants.firstIndex(where: { $0.id == id }),
           currentIndex + 1 < participants.count {
            return participants[currentIndex + 1].id
        }
        return nil
    }

    func removeIfEmpty(id: UUID) {
        if let index = participants.firstIndex(where: { $0.id == id }),
           participants[index].name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            removeParticipant(at: IndexSet(integer: index))
        }
    }
    
    func duplicateNameIndices() -> [Int] {
        var seen: Set<String> = []
        var duplicates: [Int] = []

        for (index, participant) in participants.enumerated() {
            let trimmed = participant.name.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !trimmed.isEmpty else { continue } // 공백은 무시!

            if seen.contains(trimmed) {
                duplicates.append(index)
            } else {
                seen.insert(trimmed)
            }
        }

        return duplicates
    }

    func isNameDuplicated(at index: Int) -> Bool {
        duplicateNameIndices().contains(index)
    }
}

extension ParticipantViewModel {
    func assignRoleWithShark() {
        guard participants.count >= 1 else { return }
        
        // 무작위로 1명 선택해서 조커 배정하기
        let shuffledIndices = participants.indices.shuffled()
        let sharkIndex = shuffledIndices.first!
        for i in 0..<participants.count {
            participants[i].assignedRole = nil
        }
        participants[sharkIndex].assignedRole = RoleCardProvider.roles.first(where: { $0.name == "조커" })
        
        // 나머지 역할
        var remainingRoles = RoleCardProvider.roles.filter { $0.name != "조커" }
        
        if participants.count - 1 <= remainingRoles.count {
            // 중복 없이 배정
            remainingRoles.shuffle()
            for (i, idx) in shuffledIndices.dropFirst().enumerated() {
                participants[idx].assignedRole = remainingRoles[i]
            }
        } else {
            // 중복 허용 배정
            for idx in shuffledIndices.dropFirst() {
                if let randomRole = remainingRoles.randomElement() {
                    participants[idx].assignedRole = randomRole
                }
            }
        }
        
    }
}

