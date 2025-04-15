//
//  MainView.swift
//  diver-break
//
//  Created by J on 4/13/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var roleViewModel: RoleAssignmentViewModel

    var body: some View {
        VStack(spacing: 32) {
            
            if roleViewModel.isJokerRevealed {
                CustomNavigationBar(
                    isDisplayLeftBtn: true,
                    isDisplayRightBtn: true,
                    leftBtnAction: { pathModel.popToRoot() },
                    rightBtnAction: { print("헬프 버튼 눌림") },
                    leftBtnType: .home,
                    rightBtnType: .help
                )
            }

            titleSection

            if roleViewModel.isJokerRevealed {
                revealedSummarySection
            } else {
                actionButtonGrid
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
        .background(Color.diverBackgroundBlue)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - 타이틀 영역
    private var titleSection: some View {
        VStack(spacing: 20) {
            Text("오늘의 조커")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(roleViewModel.isJokerRevealed ? roleViewModel.jokerName : "???")
//                .font(.system(size: 44, weight: .semibold))
                .font(.custom("SFProRounded-Semibold", size: 44))
                .foregroundColor(.diverBlack)
                .onAppear {
                    print("👉 참가자 수: \(roleViewModel.participants.count)")
                    roleViewModel.participants.forEach {
                        print("🔸 \($0.name): \($0.assignedRole?.name ?? "없음")")
                    }
                    print("🔍 조커 이름: \(roleViewModel.jokerName)")
                }

            Text(roleViewModel.isJokerRevealed ? "회의 끄읕" : "회의에 집중!")
                .font(.subheadline)
                .foregroundColor(.diverBlack)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - 조커 공개 전: 4개 버튼
    private var actionButtonGrid: some View {
        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
            mainButton(title: "역할 확인하기", icon: "🪪") { // TODO: - 버튼으로 구현해서 long press
                pathModel.push(.checkMyRole)
            }

            mainButton(title: "회의 삭제하기", icon: "🗑️") { // 완성
                pathModel.popToRoot()
            }

            mainButton(title: "조커 공개하기", icon: "🃏") { // 완성 (도움말은 아직)
                roleViewModel.isJokerRevealed = true
            }

            mainButton(title: "인원 추가하기", icon: "➕") { // TODO: - 역할 배부 + 기존 participants에 추가 로직 필요
                pathModel.push(.updateParticipant(existing: roleViewModel.participants))
            }
        }
    }

    // MARK: - 조커 공개 후: 참가자 요약
    private var revealedSummarySection: some View { // revealedSummarySection
        let columns: [GridItem] = [
            GridItem(.flexible(), spacing: 20),
            GridItem(.flexible(), spacing: 20)
        ]

        return ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(roleViewModel.participants) { participant in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(participant.name)
                            .font(.headline)

                        if let role = participant.assignedRole {
                            Text(role.name)
                                .font(.subheadline)
                                .foregroundColor(.diverBlue)
                            
                            Text(role.guide)
                                .font(.caption)
                                .foregroundColor(.diverGray2)
                            
                        } else {
                            Text("역할 없음")
                                .font(.subheadline)
                                .foregroundColor(.diverGray0)
                        }

                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .aspectRatio(1, contentMode: .fit)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.diverGray0, lineWidth: 1)
                    )
                }
            }
        }
    }

    // MARK: - 공통 버튼 스타일
    private func mainButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 40) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.customBlack)
                
                Text(icon)
                    .font(.largeTitle)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 180)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 1)
        }
    }
}

#Preview {
    let vm = RoleAssignmentViewModel()
    vm.participants = [
        Participant(name: "Cherry", assignedRole: RoleCardProvider.roles[1]),
        Participant(name: "HappyJay", assignedRole: RoleCardProvider.roles[6]),
        Participant(name: "Moo", assignedRole: RoleCardProvider.roles[3]),
        Participant(name: "Snow", assignedRole: RoleCardProvider.roles[4]),
        Participant(name: "Wish", assignedRole: RoleCardProvider.roles[5]),
        Participant(name: "Gigi", assignedRole: RoleCardProvider.roles[0]),
        Participant(name: "Gigi", assignedRole: RoleCardProvider.roles[0]),
    ]
//    vm.isJokerRevealed = true
    vm.isJokerRevealed = false

    return MainView()
        .environmentObject(PathModel())
        .environmentObject(vm)
}
