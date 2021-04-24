//
//  CaptureViewFactory.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 23.04.2021.
//

import Foundation

struct CaptureViewFactory {
    private let store: AppStore

    init(store: AppStore = StoreLocator.shared) {
        self.store = store
    }
    
    func makeDefault() -> CaptureViewController {
        let controller = CaptureViewController()
        var cancelObserving: Command?
        let presenter = CaptureViewControllerPresenter(
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
