//
//  RoleCardViewModel.swift
//  diver-break
//
//  Created by J on 4/13/25.
//

import Foundation

class RoleCardViewModel: ObservableObject {
    @Published var isRevealed: Bool = false

    func reveal() {
        isRevealed = true
    }
}
