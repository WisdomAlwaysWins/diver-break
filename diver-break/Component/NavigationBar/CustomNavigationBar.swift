//
//  CustomNavigationBar.swift
//  diver-break
//
//  Created by J on 4/11/25.
//

import SwiftUI

/*
    MARK: - 커스텀 네비게이션 바 컴포넌트
    - 왼쪽/ 오른쪽 버튼 각각의 표시 여부 및 타입 지정
    - 버튼 타입은 NavigationBtnType에 열거형으로 정의해둠
*/

struct CustomNavigationBar: View {
    
    let isDisplayLeftBtn : Bool
    let isDisplayRightBtn : Bool
    
    let leftBtnAction : () -> Void
    let rightBtnAction : () -> Void
    
    let leftBtnType : NavigationBtnType?
    let rightBtnType : NavigationBtnType?
    
    let leftBtnColor : Color
    let rightBtnColor : Color
    
    init(isDisplayLeftBtn: Bool = true,
         isDisplayRightBtn: Bool = true,
         leftBtnAction: @escaping () -> Void = {},
         rightBtnAction: @escaping () -> Void = {},
         leftBtnType: NavigationBtnType? = .help,
         rightBtnType: NavigationBtnType? = .play,
         leftBtnColor: Color = .diverIconGray,
         rightBtnColor: Color = .diverIconGray
    ) {
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isDisplayRightBtn = isDisplayRightBtn
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
        self.leftBtnType = leftBtnType
        self.rightBtnType = rightBtnType
        self.leftBtnColor = leftBtnColor
        self.rightBtnColor = rightBtnColor
    }
    
    
    var body: some View {
        HStack {
            // MARK: - 왼쪽 버튼
            if isDisplayLeftBtn, let type = leftBtnType {
                Button {
                    leftBtnAction()
                } label: {
                    Text(type.name)
                        .foregroundColor(leftBtnColor)
                }
            }
            
            Spacer()
            
            // MARK: - 오른쪽 버튼
            if isDisplayRightBtn, let type = rightBtnType {
                Button {
                    rightBtnAction()
                } label: {
                    Text(type.name)
                        .foregroundColor(rightBtnColor)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        //.background(Color.green) // 👀 TEST 
    }
}

#Preview {
    CustomNavigationBar()
}
