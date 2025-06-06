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
    @StateObject var participantViewModel = ParticipantInputListViewModel()
    @StateObject var roleViewModel = RoleAssignmentViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pathModel)
                .environmentObject(participantViewModel)
                .environmentObject(roleViewModel)
                .environment(\.font, .custom("SFProRounded-Regular", size: 14))
        }
    }
}



