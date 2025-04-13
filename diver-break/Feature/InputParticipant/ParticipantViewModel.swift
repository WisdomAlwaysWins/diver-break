//
//  AddNicknameViewModel.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import Foundation
import SwiftUI

class ParticipantViewModel: ObservableObject {
    @Published var participants: [Participant] = [ // 현재 입력된 참가자 목록
        Participant(name: ""),
        Participant(name: ""),
        Participant(name: "")
    ]

    @Published var submittedUsers: [Participant] = [] // 실제로 사용될 참가자

    // 공백이 아닌 유효한 이름을 가진 참가자 수
    var validParticipantCount: Int {
        participants.filter {
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }.count
    }
    
    // 중복된 이름 확인
    var hasDuplicateNames: Bool {
        let trimmedNames = participants.map { $0.name.trimmingCharacters(in: .whitespacesAndNewlines) }
        let nameSet = Set(trimmedNames.filter { !$0.isEmpty })
        return nameSet.count != trimmedNames.filter { !$0.isEmpty }.count
    }

    // 새로운 참가자 추가
    func addParticipant() {
        withAnimation {
            participants.append(Participant(name: ""))
        }
    }

    // 참가자 제거 (단, 최소 3명 유지)
    func removeParticipant(at offsets: IndexSet) {
        withAnimation {
            participants.remove(atOffsets: offsets)
            while participants.count < 3 {
                participants.append(Participant(name: ""))
            }
        }
    }

    // 주어진 ID 뒤의 참가자 ID를 반환 (포커스 이동용)
    func nextParticipantId(after id: UUID) -> UUID? {
        if let currentIndex = participants.firstIndex(where: { $0.id == id }),
           currentIndex + 1 < participants.count {
            return participants[currentIndex + 1].id
        }
        return nil
    }

    // 해당 ID의 참가자 이름이 공백이면 제거
    func removeIfEmpty(id: UUID) {
        if let index = participants.firstIndex(where: { $0.id == id }),
           participants[index].name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            removeParticipant(at: IndexSet(integer: index))
        }
    }
    
    // 중복된 이름을 가진 참가자들의 인덱스 리스트
    private func duplicateNameIndices() -> [Int] {
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

    // 특정 참가자가 중복된 이름인지 여부 확인 (UI용)
    func isNameDuplicated(at index: Int) -> Bool {
        duplicateNameIndices().contains(index)
    }
}

extension ParticipantViewModel {
    func assignRoleWithShark() {
        // 유효한 참가자만 제출
        submittedUsers = participants.filter {
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        guard submittedUsers.count >= 1 else {
            print("❗️참가자가 없습니다.")
            return
        }

        // 모든 역할 초기화
        for i in 0..<submittedUsers.count {
            submittedUsers[i].assignedRole = nil
        }

        // 조커 1명 무조건 배정
        let shuffledIndices = submittedUsers.indices.shuffled()
        let sharkIndex = shuffledIndices.first!
        submittedUsers[sharkIndex].assignedRole = RoleCardProvider.roles.first(where: { $0.name == "조커" })

        // 나머지 역할 목록
        var remainingRoles = RoleCardProvider.roles.filter { $0.name != "조커" }
        let otherIndices = shuffledIndices.dropFirst()

        if otherIndices.count <= remainingRoles.count {
            // 중복 없이 배정
            remainingRoles.shuffle()
            for (i, idx) in otherIndices.enumerated() {
                submittedUsers[idx].assignedRole = remainingRoles[i]
            }
        } else {
            // 중복 허용
            for idx in otherIndices {
                if let randomRole = remainingRoles.randomElement() {
                    submittedUsers[idx].assignedRole = randomRole
                }
            }
        }

        // 💬 역할 배정 결과 출력
        print("🃏 역할 배정 완료:")
        for user in submittedUsers {
            if let role = user.assignedRole {
                print("- \(user.name): \(role.name)")
            } else {
                print("- \(user.name): 역할 없음")
            }
        }
    }
}

