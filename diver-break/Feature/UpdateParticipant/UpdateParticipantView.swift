//
//  UpdateParticipantView.swift
//  diver-break
//
//  Created by J on 4/13/25.
//

import SwiftUI

struct UpdateParticipantView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject private var inputViewModel = ParticipantInputViewModel()
    @StateObject private var roleViewModel = RoleAssignmentViewModel()

    @FocusState private var focusedId: UUID?
    @State private var lastFocusedId: UUID?
    @State private var scrollTarget: UUID?
    @State private var isAlertPresented = false
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            contentView
        }
        .alert("입력 조건이 맞지 않습니다", isPresented: $isAlertPresented) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .navigationBarHidden(true)
    }
    
    var backgroundView: some View {
        Color(.systemBackground)
            .ignoresSafeArea()
            .onTapGesture {
                focusedId = nil
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
    
    var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
//            navigationBar
            headerArea
                .padding(.horizontal)
                .padding(.top, 20)
//            participantList
        }
    }
    
    var headerArea: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 0) {
                    Text("추가할 닉네임이 있다면\n화면을 탭해 입력해주세요.")
                        .font(.title).fontWeight(.medium)
                }
            }
        }
        .padding(20)
    }
    
    var alertMessage: String {
        if inputViewModel.validParticipantCount < 3 {
            return "참가자는 최소 3명 이상이어야 합니다."
        } else {
            return "중복된 이름이 존재합니다. 이름을 수정해주세요."
        }
    }
}

#Preview {
    UpdateParticipantView()
}
