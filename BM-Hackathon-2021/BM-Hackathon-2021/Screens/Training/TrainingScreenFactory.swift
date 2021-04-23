//
//  TrainingScreenFactory.swift
//  BM-Hackathon-2021
//
//  Created Andrii Halushka on 23.04.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

struct TrainingScreenFactory {
    private let store: AppStore
    
    init(store: AppStore = StoreLocator.shared) {
        self.store = store
    }
    
    func makeDefault() -> TrainingViewController {
        let controller = TrainingViewController.loadFromStoryboard()
        var cancelObserving: Command?
        let presenter = TrainingPresenter(
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
