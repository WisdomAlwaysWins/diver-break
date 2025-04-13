//
//  diver_breakApp.swift
//  diver-break
//
//  Created by J on 4/11/25.
//

import SwiftUI

@main
struct diver_breakApp: App {
    
    @StateObject var pathModel = PathModel()
    
    let exampleParticipant = Participant(
        name: "지혜",
        assignedRole: Role(
            name: "에너지 체커",
            description: "다이버의 에너지를 확인하고 당보충 아이디어를 제공합니다.",
            guide: "에너지 레벨 물어보기, “간식 타임?” 물어보기",
            imageName: "energychecker"
        )
    )

    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $pathModel.paths) {
                
            }
            ParticipantInputListView()
//            RoleCardRevealView(participant: exampleParticipant)
        }
    }
}

