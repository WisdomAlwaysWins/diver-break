//
//  CheckRolesView.swift
//  diver-break
//
//  Created by J on 4/13/25.
//

import SwiftUI

struct CheckRolesView: View {
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var roleViewModel : RoleAssignmentViewModel
    
    @State private var revealedId: UUID? = nil

    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            contentView
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - View 구성
private extension CheckRolesView {
    
    var backgroundView: some View {
        Color(.systemBackground)
            .ignoresSafeArea()
    }

    var contentView: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            navigationBar

            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                    ForEach(roleViewModel.participants) { participant in
                        CheckMyCardView(
                            participant: participant,
                            revealedId: $revealedId
                        )
                    }
                }
            }
            .padding()

        }
        .padding(.bottom, 20)
    }

    var navigationBar: some View {
        CustomNavigationBar(
            isDisplayRightBtn: false,
            leftBtnAction: { pathModel.pop() },
            leftBtnType: .back
        )
        .padding(.horizontal)
        .padding(.top, 12)
    }
}

#Preview {
    let pathModel = PathModel()
    let roleViewModel = RoleAssignmentViewModel()

    roleViewModel.participants = [
        Participant(name: "HappyJay", assignedRole: Role(
            name: "에너지 체커",
            description: "다이버의 에너지를 확인하고 당보충 아이디어를 제공합니다.",
            guide: "에너지 레벨 물어보기, “간식 타임?” 물어보기",
            imageName: "energychecker3d"
        )),
        Participant(name: "Gigi", assignedRole: Role(
            name: "거북목 보안관",
            description: "거북목 같은 디스크를 예방하고 다이버를 보호합니다.",
            guide: "손목 / 목 스트레칭하기 또는 눈 감고 휴식하기",
            imageName: "discguardian3d"
        ))
    ]

    return CheckRolesView()
        .environmentObject(pathModel)
        .environmentObject(roleViewModel)
}
