//
//  PathModel.swift
//  diver-break
//
//  Created by J on 4/13/25.
//

import Foundation

class PathModel : ObservableObject {
    @Published var paths : [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
    
    func push(_ path : PathType) {
        paths.append(path)
    }
    
    func pop() {
        _ = paths.popLast()
    }
    
    func popToRoot() {
        paths = [.participantInput]
    }
    
    func replace(with path: PathType) {
        paths = [path]
    }
    
    func resetTo(_ path: PathType) {
        paths = [path] // 현재 스택 전체 초기화 후 단 하나만 push
    }
}
