//
//  ExerciseVideoPlayerPresenter.swift
//  BM-Hackathon-2021
//
//  Created Andrii Halushka on 23.04.2021.
//  Copyright © 2021 Andrii Halushka. All rights reserved.
//

import Foundation

struct ExerciseVideoPlayerPresenter {
    typealias Props = ExerciseVideoPlayerViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let endObserving: Command
    
    func present(state: AppState) {
        render.perform(
            with: Props(
                url: state.trainingScreen.exerciseVideoURL,
                onDestroy: endObserving
            )
        )
    }
}
