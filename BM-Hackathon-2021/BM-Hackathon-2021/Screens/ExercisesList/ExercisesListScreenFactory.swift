//
//  ExercisesListScreenFactory.swift
//  BM-Hackathon-2021
//
//  Created Andrii Halushka on 24.04.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

struct ExercisesListScreenFactory {
    private let store: AppStore
    
    init(store: AppStore = StoreLocator.shared) {
        self.store = store
    }
    
    func `default`() -> ExercisesListViewController {
        let controller = ExercisesListViewController.loadFromStoryboard()
        var cancelObserving: Command?
        let presenter = ExercisesListPresenter(
            render: CommandWith { [weak controller] props in
                controller?.render(props: props)
            }.dispatched(on: .main),
            dispatch: CommandWith { [weak store] action in
                store?.dispatch(action: action)
            },
            endObserving: Command { cancelObserving?.perform() }
        )
        cancelObserving = store.observe(with: CommandWith(action: presenter.present))
        return controller
    }
}
