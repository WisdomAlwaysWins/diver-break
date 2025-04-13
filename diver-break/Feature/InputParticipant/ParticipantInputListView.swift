//
//  AddNicknameView.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import SwiftUI

// MARK: - Main View
struct ParticipantInputListView: View {
    @StateObject private var viewModel = ParticipantViewModel()
    @FocusState private var focusedId: UUID?
    @State private var lastFocusedId: UUID?
    @State private var scrollTarget: UUID?
    
    @State private var isAlertPresented = false
//    @State private var showDuplicateAlert = false
    @State private var navigateToReveal = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                backgroundView // MARK: - 전체 배경 및 키보드 내리기 처리
                contentView // MARK: - 상단 설명 영역 + 참가자 리스트
                
                NavigationLink (
                    destination : RoleCardRevealView(participants: viewModel.participants),
                    isActive : $navigateToReveal
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .alert("참가자 최소 3명 이상", isPresented: $isAlertPresented) {
                Button("확인", role : .cancel) {}
            }
        }
    }
    
    // 전체 배경 영역 + 탭하면 키보드 내리기
    private var backgroundView : some View {
        Color(.systemBackground)
            .ignoresSafeArea()
            .onTapGesture {
                focusedId = nil
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
            }
    }
    
    // 네비게시션 바 + 상단 설명 영역 + 참가자 리스트 구성
    private var contentView : some View {
        VStack(alignment: .leading, spacing: 0) {

            navigationBar
            
            headerArea
                .padding(.horizontal)
                .padding(.top, 20)

            participantList
        }
        .navigationBarHidden(true)
    }
    
    // 네이게이션 바
    private var navigationBar : some View {
        CustomNavigationBar(
            isDisplayLeftBtn: true,
            isDisplayRightBtn: true,
            leftBtnAction: { print("도움말 눌림")},
            rightBtnAction: {
                print("플레이 눌림")
                if viewModel.validParticipantCount < 3 {
                    isAlertPresented = true
                } else {
                    // MARK: - 확인용~~~~
                    let names = viewModel.participants.map { $0.name }
                    print("등록된 참가자들 \(names.count)명 : ")
                    names.forEach { print("-\($0)") }
                    
                    viewModel.assignRoleWithShark()
                    navigateToReveal = true
                }
            },
            leftBtnType: .help,
            rightBtnType: .play,
            leftBtnColor: .primary,
            rightBtnColor: viewModel.validParticipantCount >= 3 ? .diverBlue : .primary
        )
        .padding(.horizontal,20)
        .padding(.top, 12)
    }
    
    // 참가자 입력 리스트 영역 (Scroll view + List view)
    private var participantList: some View {
        ScrollViewReader { proxy in
            List {
                // Section Header
                Section(
                    header:
                        HStack {
                            Spacer()
                            Text("현재 \(viewModel.validParticipantCount)명 참여")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.diverBlack)
                                .padding(.vertical, 4)
                        }
                ) {
                    // 참가자 셀 목록
                    ForEach(Array(zip(viewModel.participants.indices, $viewModel.participants)), id: \.1.id) { index, $participant in
                        ParticipantCellView(
                            participant: $participant,
                            index : index,
                            isDuplicate : viewModel.isNameDuplicated(at: index),
                            onDelete: {
                                viewModel.removeParticipant(at: IndexSet(integer: index))
                            }
                        )
                        .id(participant.id)
                        .focused($focusedId, equals: participant.id)
                        .onSubmit {
                            handleSubmit(index: index, participant: participant)
                        }
                        .listRowBackground(Color.clear)
                    }

                    // 새로운 이름 추가 버튼
                    Button(action: addParticipant) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.diverBlue)
                            Text("새로운 이름")
                                .foregroundColor(.diverBlue)
                                .fontWeight(.bold)
                                .font(.headline)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .padding(.horizontal, 20)
            .onChange(of: scrollTarget) { id in
                if let id = id {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .center)
                    }
                }
            }
            .onChange(of: focusedId) { newValue in
                if newValue == nil, let lastId = lastFocusedId {
                    viewModel.removeIfEmpty(id: lastId)
                }
                lastFocusedId = newValue
            }
        }
    }
    
    // 상단 안내 텍스트 영역
    private var headerArea: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("조커는 딱 ")
                    Text("1")
                        .foregroundColor(Color.diverBlue)
                    Text("명입니다.")
                }
                .font(.title)
                .fontWeight(.medium)
                .lineSpacing(4)
                
                Text("역할은 무작위로 정해집니다.")
                    .font(.title)
                    .fontWeight(.medium)
                    .lineSpacing(4)
            }
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("팀원은 최소 ")
                            Text("3")
                                .foregroundColor(Color.diverBlue)
                            Text("명이 필요합니다.")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineSpacing(4)
                        
                        Text("아래에 팀원들의 이름을 작성해주세요.")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineSpacing(4)
                    }
                    
                }
            }
        }
        .padding(20)
    }
        
    // 참가자 입력 셀 하나 + 삭제 버튼
    struct ParticipantCellView: View {
        @Binding var participant: Participant
        let index : Int
        let isDuplicate : Bool
        let onDelete: () -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 12) {
                    TextField("이름을 입력하세요.", text: $participant.name)
                        .submitLabel(.next)
                        .padding(.vertical, 4)
                        .foregroundColor(isDuplicate ? .red : .primary)
                    
                    Button(action: onDelete) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.diverGray2)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                if isDuplicate {
                    Text("중복된 이름이에요!")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        
    }
}

extension ParticipantInputListView {
    
    // 새로운 참가자 추가 후, 포커스 이동
    private func addParticipant() {
        viewModel.addParticipant()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let last = viewModel.participants.last {
                focusedId = last.id
                scrollTarget = last.id
            }
        }
    }

    // 입력 완료 시 유효성 검사 후 포커스 검사
    // 아무것도 없으면 셀 삭제
    private func handleSubmit(index: Int, participant: Participant) {
        let trimmed = participant.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            viewModel.removeParticipant(at: IndexSet(integer: index))
        } else if let nextId = viewModel.nextParticipantId(after: participant.id) {
            focusedId = nextId
            scrollTarget = nextId
        }
    }
}


#Preview {
    ParticipantInputListView()
}
