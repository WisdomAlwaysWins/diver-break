//
//  CustomNavigationBar.swift
//  diver-break
//
//  Created by J on 4/11/25.
//

import SwiftUI

struct CustomNavigationBar: View {
    
    let isDisplayLeftBtn : Bool
    let isDisplayRightBtn : Bool
    
    let leftBtnAction : () -> Void
    let rightBtnAction : () -> Void
    
    let leftBtnType : NavigationBtnType?
    let rightBtnType : NavigationBtnType?
    
    init(isDisplayLeftBtn: Bool = true,
         isDisplayRightBtn: Bool = true,
         leftBtnAction: @escaping () -> Void = {},
         rightBtnAction: @escaping () -> Void = {},
         leftBtnType: NavigationBtnType? = .help,
         rightBtnType: NavigationBtnType? = .play) {
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isDisplayRightBtn = isDisplayRightBtn
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
        self.leftBtnType = leftBtnType
        self.rightBtnType = rightBtnType
    }
    
    
    var body: some View {
        HStack {
            // MARK: - 왼쪽 버튼
            if isDisplayLeftBtn, let type = leftBtnType {
                Button {
                    leftBtnAction()
                } label: {
                    Image(systemName: type.iconName)
                        .foregroundColor(.primary)
                }
            }
            Spacer()
            
            // MARK: - 오른쪽 버튼
            if isDisplayRightBtn, let type = rightBtnType {
                Button {
                    rightBtnAction()
                } label: {
                    Image(systemName: type.iconName)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 20)
        .background(Color.green)
    }
}

#Preview {
    CustomNavigationBar()
}
