//
//  RoleAssignmentViewModel.swift
//  diver-break
//
//  Created by J on 4/13/25.
//

import Foundation
import SwiftUI

/*
    MARK: - 역할 배정 및 참가자 상태를 관리하는 ViewModel
    - 참가자 목록, 역할 배정, 조커 공개 여부
*/

class RoleAssignmentViewModel: ObservableObject {
    @Published var participants: [Participant] = [] // 전체 참가자 리스트 (입력 완료된 상태임)
    @Published var isJokerRevealed = false // 조커 공개 여부 (main view에서 전환을 위해)
    
    var jokerName: String {
        participants.first(where: { $0.assignedRole?.name == "조커" })?.name ?? "???"
    } // 현재 조커의 이름

    func assignRoles(from tempParticipants: [Participant]) { // 역할 초기 배정
        isJokerRevealed = false
        
        participants = tempParticipants.filter { // 유효 참가자만 필터링
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        guard !participants.isEmpty else {
            print("❗️참가자가 없습니다.")
            return
        }

        // 기존 역할이 있었다면 제거
        participants.indices.forEach { participants[$0].assignedRole = nil }

        // 조커 배정
        let shuffledIndices = participants.indices.shuffled()
        if let shark = RoleCardProvider.roles.first(where: { $0.name == "조커" }) {
            participants[shuffledIndices[0]].assignedRole = shark
        }

        // 나머지 역할 배정
        var remainingRoles = RoleCardProvider.roles.filter { $0.name != "조커" }
        let others = shuffledIndices.dropFirst()

        if others.count <= remainingRoles.count { // 중복이 없이 배정 가능하다면
            remainingRoles.shuffle()
            for (i, idx) in others.enumerated() {
                participants[idx].assignedRole = remainingRoles[i]
            }
        } else { // 인원이 많아 중복되야한다면
            for idx in others {
                participants[idx].assignedRole = remainingRoles.randomElement()
            }
        }

        print("🃏 역할 배정 완료:")
        participants.forEach {
            print("- \($0.name): \($0.assignedRole?.name ?? "없음")")
        }
    }
    
    func appendNewParticipants(_ newOnes: [Participant]) { // 기존 인원에 새 인원 추가 (중복 방지)
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
        let uniqueNew = validNew.filter { !existingNames.contains($0.name) }

        guard !uniqueNew.isEmpty else {
            print("모든 새 참가자가 기존에 이미 포함되어 있음")
            return
        }

        let totalCount = participants.count + uniqueNew.count
        var newAssigned: [Participant] = []

        let assignedRoleNames = Set(participants.compactMap { $0.assignedRole?.name })
        var availableRoles = RoleCardProvider.roles
            .filter { $0.name != "조커" && !assignedRoleNames.contains($0.name) }

        for participant in uniqueNew {
            var assignedRole: Role?

            if totalCount <= 7, !availableRoles.isEmpty {
                assignedRole = availableRoles.removeFirst()
            } else {
                let roles = RoleCardProvider.roles.filter { $0.name != "조커" }
                assignedRole = roles.randomElement()
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
