//
//  CaptureViewControllerPresenter.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 24.04.2021.
//

import Foundation

extension Actions {
    enum CaptureViewControllerPresenter {
        struct ActionDetected: Action {
            let action: ActionPredictor.Action
        }
    }
}

struct CaptureViewControllerPresenter {
    typealias Props = CaptureViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let endObserving: Command
    
    func present(state: AppState) {
        render.perform(
            with: Props(
                onDetectedAction: CommandWith {
                    dispatch.perform(with: Actions.CaptureViewControllerPresenter.ActionDetected(action: $0))
                },
                onDestroy: endObserving
            )
        )
    }
}
