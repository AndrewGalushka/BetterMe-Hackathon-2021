//
//  AppDelegate.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 22.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private lazy var store = AppStore(state: AppState(), reducer: reduce, middlewares: [])
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        StoreLocator.populate(with: store)
        return true
    }
}

