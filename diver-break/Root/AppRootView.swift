//
//  AppRootView.swift
//  diver-break
//
//  Created by J on 4/13/25.
//

import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var pathModel : PathModel
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            ParticipantInputListView() // 첫 시작 화면
                .navigationDestination(for: PathType.self) { path in
                    switch path {
                    case .participantInput :
                        ParticipantInputListView()
                    case .roleReveal(let participants) :
                        RoleCardRevealView(participants: participants)
                    case .main :
                        MainView()
                    case .checkMyRole :
                        CheckRolesView()
                    case .updateParticipant(let existing) :
                        UpdateParticipantView(existingParticipants: existing)
                        
                    }
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AppRootView()
        .environmentObject(PathModel())
        .environmentObject(ParticipantInputViewModel())
        .environmentObject(RoleAssignmentViewModel())
}
