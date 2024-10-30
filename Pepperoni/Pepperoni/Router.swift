//
//  Router.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/27/24.
//

import Foundation
import SwiftUI


// MARK: - Route Enum
enum Destination: Hashable {
    case home
    case search
    case learning(id: String)
    case result(score: Int)
}

// MARK: - Router
final class Router: ObservableObject {
    // 싱글톤 패턴 적용
    static let shared = Router()
    
    @Published var navPath = NavigationPath()
    
    private init() {}
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func navigateBack() {
        guard !navPath.isEmpty else { return }
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
