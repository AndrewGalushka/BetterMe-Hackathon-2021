//
//  SettingsPresenter.swift
//  BM-Hackathon-2021
//
//  Created Andrii Halushka on 24.04.2021.
//  Copyright © 2021 Andrii Halushka. All rights reserved.
//

import Foundation

extension Actions {
    enum SettingsPresenter {
        struct ShowPredictionsChange: Action {
            let isOn: Bool
        }
        
        struct ShowPointsChange: Action {
            let isOn: Bool
        }
    }
}

struct SettingsPresenter {
    typealias Props = SettingsViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let endObserving: Command
    
    func present(state: AppState) {
        render.perform(
            with: Props(
                isPredictionsOn: state.settings.showPredictions,
                isPointsOn: state.settings.showPoints,
                onShowPredictionChange: CommandWith {
                    dispatch.perform(with: Actions.SettingsPresenter.ShowPredictionsChange(isOn: $0))
                },
                onShowPointsChange: CommandWith {
                    dispatch.perform(with: Actions.SettingsPresenter.ShowPointsChange(isOn: $0))
                },
                onDestroy: endObserving
            )
        )
    }
}
