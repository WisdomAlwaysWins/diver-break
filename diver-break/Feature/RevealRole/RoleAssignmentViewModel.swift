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
        isJokerRevealed = false
        
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
    
    func appendNewParticipants(_ newOnes: [Participant]) {
        let existingIds = Set(participants.map { $0.id })
        let filtered = newOnes.filter { !existingIds.contains($0.id) }
        participants.append(contentsOf: filtered)
    }
    
    func assignRolesToNewParticipants(_ newParticipants: [Participant]) {
        let validNew = newParticipants
            .filter { !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

        guard !validNew.isEmpty else {
            print("❗️새로운 참가자가 없습니다.")
            return
        }

        let existingNames = Set(participants.map { $0.name })

        // 새로 추가된 인원 중 기존 인원과 겹치지 않는 이름만 추출
        let uniqueNew = validNew.filter { !existingNames.contains($0.name) }

        guard !uniqueNew.isEmpty else {
            print("모든 새 참가자가 기존에 이미 포함되어 있음")
            return
        }

        var availableRoles = RoleCardProvider.roles.filter { $0.name != "조커" }

        let existingCount = participants.count

        var newAssigned: [Participant] = []

        for participant in uniqueNew {
            var assignedRole: Role?

            if existingCount < 7 && !availableRoles.isEmpty {
                assignedRole = availableRoles.removeFirst()
            } else {
                assignedRole = availableRoles.randomElement()
            }

            newAssigned.append(
                Participant(id: participant.id, name: participant.name, assignedRole: assignedRole)
            )
        }

        participants.append(contentsOf: newAssigned)

        print("✅ 새 인원 역할 배정 완료:")
        newAssigned.forEach {
            print("- \($0.name): \($0.assignedRole?.name ?? "없음")")
        }
    }
}
