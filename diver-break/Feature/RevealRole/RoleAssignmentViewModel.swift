//
//  RoleAssignmentViewModel.swift
//  diver-break
//
//  Created by J on 4/13/25.
//

import Foundation
import SwiftUI

class RoleAssignmentViewModel: ObservableObject {
    @Published var participants: [Participant] = []
    @Published var isJokerRevealed = false
    
    var jokerName: String {
        participants.first(where: { $0.assignedRole?.name == "조커" })?.name ?? "???"
    }

    func assignRoles(from tempParticipants: [Participant]) {
        participants = tempParticipants.filter {
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        guard !participants.isEmpty else {
            print("❗️참가자가 없습니다.")
            return
        }

        // 초기화
        participants.indices.forEach { participants[$0].assignedRole = nil }

        // 조커
        let shuffledIndices = participants.indices.shuffled()
        if let shark = RoleCardProvider.roles.first(where: { $0.name == "조커" }) {
            participants[shuffledIndices[0]].assignedRole = shark
        }

        var remainingRoles = RoleCardProvider.roles.filter { $0.name != "조커" }
        let others = shuffledIndices.dropFirst()

        if others.count <= remainingRoles.count {
            remainingRoles.shuffle()
            for (i, idx) in others.enumerated() {
                participants[idx].assignedRole = remainingRoles[i]
            }
        } else {
            for idx in others {
                participants[idx].assignedRole = remainingRoles.randomElement()
            }
        }

        print("🃏 역할 배정 완료:")
        participants.forEach {
            print("- \($0.name): \($0.assignedRole?.name ?? "없음")")
        }
    }
}
