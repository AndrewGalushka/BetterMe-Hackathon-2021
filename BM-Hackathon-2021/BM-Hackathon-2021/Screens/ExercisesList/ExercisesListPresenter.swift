//
//  ExercisesListPresenter.swift
//  BM-Hackathon-2021
//
//  Created Andrii Halushka on 24.04.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

struct ExercisesListPresenter {
    typealias Props = ExercisesListViewController.Props
    
    let render: CommandWith<Props>
    let dispatch: CommandWith<Action>
    let endObserving: Command
    
    func present(state: AppState) {
        render.perform(
            with: Props(
                onDestroy: endObserving
            )
        )
    }
}
