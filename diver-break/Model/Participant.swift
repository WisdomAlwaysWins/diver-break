//
//  Participant.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import Foundation

struct Participant : Identifiable, Hashable {
    let id = UUID()
    var name : String // MARK: - 수정 가능하게 할까 말까 일단 나중을 위해 할 수 있게 두자
    var role : Role // MARK: - 얘도
}
