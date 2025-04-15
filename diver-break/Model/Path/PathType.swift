//
//  PathType.swift
//  diver-break
//
//  Created by J on 4/13/25.
//

import Foundation

enum PathType: Hashable {
    case participantInput
    case roleReveal(participants: [Participant])
    case main
    case checkMyRole
    case updateParticipant(existing: [Participant])
}
