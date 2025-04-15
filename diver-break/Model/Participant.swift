//
//  Participant.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import Foundation

struct Participant : Identifiable, Hashable {
    let id : UUID
    var name : String // MARK: - 수정 가능하게 할까 말까 일단 나중을 위해 할 수 있게 두자
    var assignedRole : Role? // MARK: - nil 가능 -> 처음에 닉네임 받자마자 롤을 배정받는 건 아니니까
    
    init(id : UUID = UUID(), name: String = "", assignedRole: Role? = nil) {
        self.id = id
        self.name = name
        self.assignedRole = assignedRole
    }
}

extension Participant {
    var trimmedName : String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValid : Bool {
        !trimmedName.isEmpty
    }
}
