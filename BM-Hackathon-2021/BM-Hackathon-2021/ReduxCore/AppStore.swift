//
//  Store.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 22.04.2021.
//

import Foundation

typealias AppStore = Store<AppState>

class StoreLocator {
    private static var store: Store<AppState>?
    
    static func populate(with store: Store<AppState>) {
        self.store = store
    }
    
    static var shared: Store<AppState> {
        guard let store = store else {
            fatalError("Store is not populated into locator")
        }
        
        return store
    }
}
