//
//  AppCoordinator.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 22.04.2021.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    private let navigationController = UINavigationController(rootViewController: UIViewController())
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = makeInitialScreen()
        window.makeKeyAndVisible()
    }
}

private extension AppCoordinator {
    func makeInitialScreen() -> UIViewController {
        let vc = CaptureViewController()
        return vc
    }
}
