//
//  DynamicInputListView.swift
//  diver-break
//
//  Created by J on 4/12/25.
//

import SwiftUI

import SwiftUI

/// 재사용 가능한 입력 리스트 뷰 (텍스트 필드 목록)
struct DynamicInputListView: View {
    @Binding var items: [String]
    var minCount: Int = 1
    var placeholder: String = "이름을 입력하세요"
    var onCommit: (() -> Void)? = nil

    @FocusState private var focusedId: UUID?
    @State private var idMap: [UUID] = []

    var body: some View {
        VStack(spacing: 12) {
            ForEach(items.indices, id: \.self) { index in
                DynamicInputItemView(
                    index: index,
                    text: $items[index],
                    placeholder: placeholder,
                    showDelete: items.count > minCount,
                    onDelete: {
                        items.remove(at: index)
                        idMap.remove(at: index)
                    }
                )
                .focused($focusedId, equals: idMap.indices.contains(index) ? idMap[index] : nil)
                .onSubmit {
                    moveFocus(after: index)
                }
            }

            Button(action: addItem) {
                Label("새로운 이름", systemImage: "plus.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .onAppear {
            idMap = items.map { _ in UUID() }
        }
        .onChange(of: items.count) { _ in
            if idMap.count != items.count {
                idMap = items.map { _ in UUID() }
            }
        }
    }

    private func addItem() {
        items.append("")
        idMap.append(UUID())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            focusedId = idMap.last
        }
    }

    private func moveFocus(after index: Int) {
        guard index + 1 < idMap.count else {
            focusedId = nil
            onCommit?()
            return
        }
        focusedId = idMap[index + 1]
    }
}
