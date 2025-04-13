//
//  DynamicInputItemView.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import SwiftUI

/// 개별 입력 셀 (텍스트 필드 + 삭제 버튼)
struct DynamicInputItemView: View {
    let index: Int
    @Binding var text: String
    var placeholder: String = "이름을 입력하세요."
    var showDelete: Bool = true
    var onDelete: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            Text("\(index + 1).")
                .foregroundColor(.secondary)

            TextField(placeholder, text: $text)
                .submitLabel(.next)
                .foregroundColor(.primary)

            if showDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 8)
    }
}
