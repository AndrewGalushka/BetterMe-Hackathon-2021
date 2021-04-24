//
//  SettingsScreenFactory.swift
//  BM-Hackathon-2021
//
//  Created Andrii Halushka on 24.04.2021.
//  Copyright © 2021 Andrii Halushka. All rights reserved.
//

import UIKit

struct SettingsScreenFactory {
    private let store: AppStore
    
    init(store: AppStore = StoreLocator.shared) {
        self.store = store
    }
    
    func makeDefault() -> SettingsViewController {
        let controller = SettingsViewController.loadFromStoryboard()
        var cancelObserving: Command?
        let presenter = SettingsPresenter(
            render: CommandWith { [weak controller] props in
                controller?.render(props: props)
            }.dispatchedOnMain(),
            dispatch: CommandWith { [weak store] action in
                store?.dispatch(action: action)
            },
            endObserving: Command { cancelObserving?.perform() }
        )
        cancelObserving = store.observe(with: CommandWith(action: presenter.present))
        return controller
    }
}
