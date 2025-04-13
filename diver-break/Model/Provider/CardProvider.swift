//
//  CardProvider.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import SwiftUI

struct RoleCardProvider {
    static let roles: [Role] = [
        Role(
            name: "에너지 체커",
            description: "다이버의 에너지를 확인하고 당보충 아이디어를 제공합니다.",
            guide: "에너지 레벨 물어보기, “간식 타임?” 물어보기",
            imageName: "energychecker3d"
        ),
        Role(
            name: "개인시간 서포터",
            description: "혼자만의 시간을 제안하고 개별 휴식 방법을 안내합니다.",
            guide: "개인공간에서 간단히 쉬기 / 개별 선택 제안하기",
            imageName: "metimesupporter3d"
        ),
        Role(
            name: "분위기 조종사",
            description: "뜨거운 분위기를 위해 지나치게 조용한 분위기를 걷어냅니다.",
            guide: "분위기 환기 멘트 던지기, 팀 응원 제스처 제안하기",
            imageName: "flowcontroller3d"
        ),
        Role(
            name: "거북목 보안관",
            description: "거북목 같은 디스크를 예방하고 다이버를 보호합니다.",
            guide: "손목 / 목 스트레칭하기 또는 눈 감고 휴식하기",
            imageName: "discguardian3d"
        ),
        Role(
            name: "산소 마스터",
            description: "집중력과 피로도를 개선하기 위해 산소 채우는 휴식을 안내합니다.",
            guide: "몸을 일으켜 호흡하기, 바깥 공기 쐬고 오기",
            imageName: "oxygenmaster3d"
        ),
        Role(
            name: "공간이동 전문가",
            description: "일상을 탈피하여 다양한 회의 장소를 제안합니다.",
            guide: "회의를 카페에서? / 공유오피스 이용해보기",
            imageName: "boatnavigator3d"
        ),
        Role(
            name: "조커",
            description: "조커는 모든 역할들의 휴식 자격을 수행할 수 있습니다.",
            guide: "분위기 환기, 노래 틀기, 스티커 붙이기, 원하는 역할 선택해서 행동해보기, “간식 타임?” 말해보기",
            imageName: "joker3d"
        )
    ]
}


//struct Role : Hashable {
//    let name : String
//    let description : String
//    let guide : String
//    let imageName : String
//}
