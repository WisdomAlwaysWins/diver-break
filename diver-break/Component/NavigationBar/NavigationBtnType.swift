//
//  NavigationBtnType.swift
//  diver-break
//
//  Created by J on 4/11/25.
//

import Foundation

enum NavigationBtnType : String {
    case back = "뒤로 가기"
    case home = "홈으로"
    case help = "도움말"
    case play = "시작하기"
    
    var iconName : String {
        switch self {
        case .back : return "chevron.left"
        case .home : return "house"
        case .help : return "questionmark.circle"
        case .play : return "play.fill"
        }
    }
    
    var name : String {
        self.rawValue
    }
}
