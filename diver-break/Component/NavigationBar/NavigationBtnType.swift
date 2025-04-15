//
//  NavigationBtnType.swift
//  diver-break
//
//  Created by J on 4/11/25.
//

import Foundation

/*
    MARK: - 네비게이션 바 타입을 정의하는 enum
    - 텍스트로 구성
    - CustomNavigationBar에서 버튼 구성 시 사용함
*/

enum NavigationBtnType : String {
    case back = "뒤로 가기"
    case home = "홈으로"
    case help = "도움말"
    case play = "시작하기"
    
    var name : String {
        self.rawValue
    }
}
