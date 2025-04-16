//
//  AddNicknameViewModel.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import Foundation
import SwiftUI

class ParticipantInputListViewModel: ObservableObject {
    @Published var tempParticipants: [Participant] = [
        Participant(name: ""), Participant(name: ""), Participant(name: "")
    ]
    
    var validParticipantCount: Int {
        tempParticipants.filter { !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }.count
    }

    var hasDuplicateNames: Bool {
        let trimmed = tempParticipants.map { $0.name.trimmingCharacters(in: .whitespacesAndNewlines) }
        return Set(trimmed.filter { !$0.isEmpty }).count != trimmed.filter { !$0.isEmpty }.count
    }
    
    func addParticipant() {
        withAnimation {
            tempParticipants.append(Participant(name: ""))
        }
    }

    func removeParticipant(at offsets: IndexSet) {
        withAnimation {
            tempParticipants.remove(atOffsets: offsets)
            while tempParticipants.count < 3 {
                tempParticipants.append(Participant(name: ""))
            }
        }
    }

    func nextParticipantId(after id: UUID) -> UUID? {
        if let currentIndex = tempParticipants.firstIndex(where: { $0.id == id }),
           currentIndex + 1 < tempParticipants.count {
            return tempParticipants[currentIndex + 1].id
        }
        return nil
    }

    func removeIfEmpty(id: UUID) {
        if let index = tempParticipants.firstIndex(where: { $0.id == id }),
           tempParticipants[index].name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            removeParticipant(at: IndexSet(integer: index))
        }
    }

    func isNameDuplicated(at index: Int) -> Bool {
        var seen: Set<String> = []
        for (i, p) in tempParticipants.enumerated() {
            let trimmed = p.name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { continue }
            if seen.contains(trimmed), i == index { return true }
            seen.insert(trimmed)
        }
        return false
    }
}
