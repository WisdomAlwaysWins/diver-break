//
//  ParticipantManager.swift
//  diver-break
//
//  Created by J on 4/16/25.
//

import Foundation

class ParticipantManager {
    
    var participants : [Participant] = []

    // MARK: - create
    func add(_ participant: Participant) {
        guard participant.isValid else { return }
        participants.append(participant)
    }
    
    // MARK: - update
    func update(_ participant: Participant) {
        guard let index = participants.firstIndex(where: { $0.id == participant.id }) else { return }
        participants[index] = participant
    }
    
    // MARK: - remove by uuid
    func remove(id: UUID) {
        participants.removeAll { $0.id == id }
    }

    // MARK: - remove by 객체 그잡채
    func remove(_ participant: Participant) {
        remove(id: participant.id)
    }

    // MARK: - remove All
    func removeAll() {
        participants.removeAll()
    }
    
    // MARK: - validation
    func isNameDuplicated(_ name: String) -> Bool {
        participants.map { $0.name }.filter { $0 == name }.count > 1
    }
    
    // MARK: - role assignment
    func assignRoles(with provider: RoleCardProvider) {
        //TODO: - 역할 배정 로직 이리로 옮겨와라~
    }
    
    // set
    func setParticipants(_ newParticipants: [Participant]) {
        participants = newParticipants
    }

    // get
    func getParticipants() -> [Participant] {
        return participants
    }
}


