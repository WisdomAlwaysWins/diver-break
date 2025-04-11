//
//  ContentView.swift
//  diver-break
//
//  Created by J on 4/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("기본 상단바 화면", destination: DefaultTopBarView())
                NavigationLink("커스텀 상단바 화면", destination: CustomTopBarView())
            }
        }
    }
}

struct DefaultTopBarView: View {
    var body: some View {
        Text("기본 상단바 사용")
            .navigationBarTitle("기본", displayMode: .inline)
            .navigationBarItems(trailing: Button("추가") {})
    }
}

struct CustomTopBarView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { /* 뒤로가기 */ }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text("커스텀 타이틀")
                    .font(.headline)
                Spacer()
                Button("편집") {}
            }
            .padding()
            .background(Color.gray.opacity(0.1))

            Spacer()
            Text("이 화면은 커스텀 상단바")
            Spacer()
        }
        .navigationBarHidden(true) // ✅ 반드시 숨겨줘야 겹치지 않아!
    }
}

#Preview {
    ContentView()
}
