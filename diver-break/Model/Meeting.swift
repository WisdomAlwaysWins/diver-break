//
//  Meeting.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import Foundation

struct Meeting : Hashable {
    var participants : [Participant]
    
    var participantsCount : Int {
        participants.count
    }
}
