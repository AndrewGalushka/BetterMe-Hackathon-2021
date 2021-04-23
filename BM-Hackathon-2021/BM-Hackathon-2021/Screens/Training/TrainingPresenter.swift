//
//  TrainingPresenter.swift
//  BM-Hackathon-2021
//
//  Created Andrii Halushka on 23.04.2021.
//  Copyright © 2021 Andrii Halushka. All rights reserved.
//

import Foundation

extension Actions {
    enum TrainingPresenter {
        struct ExerciseVideoTap: Action {}
    }
}

struct TrainingPresenter {
    typealias Props = TrainingViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let endObserving: Command
    
    func present(state: AppState) {
        render.perform(
            with: Props(
                exerciseVideoState: state.trainingScreen.exerciseVideoState,
                onExerciseVideoTap: dispatch.bind(to: Actions.TrainingPresenter.ExerciseVideoTap()),
                onDestroy: endObserving
            )
        )
    }
}
