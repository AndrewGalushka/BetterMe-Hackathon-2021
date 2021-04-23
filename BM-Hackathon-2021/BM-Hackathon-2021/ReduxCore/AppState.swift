//
//  AppState.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 22.04.2021.
//

import Foundation

struct AppState: Equatable {
    private(set) var trainingScreen: TrainingScreenState
    
    static var initial: AppState {
        AppState(trainingScreen: .initial)
    }
}

func reduce(_ state: AppState, with action: Action) -> AppState {
    AppState(
        trainingScreen: reduce(state.trainingScreen, with: action)
    )
}

// MARK: - TrainingScreenState

struct TrainingScreenState: Equatable {
    let exerciseVideoState: ExerciseVideoState
    
    static var initial: TrainingScreenState {
        return TrainingScreenState(exerciseVideoState: .maximised)
    }
    
    enum ExerciseVideoState: Equatable {
        case minimised
        case maximised
    }
}

func reduce(_ state: TrainingScreenState, with action: Action) -> TrainingScreenState {
    switch action {
    case is Actions.TrainingPresenter.ExerciseVideoTap:
        switch state.exerciseVideoState {
        case .minimised:
            return TrainingScreenState(exerciseVideoState: .maximised)
        case .maximised:
            return TrainingScreenState(exerciseVideoState: .minimised)
        }
    default:
        return state
    }
}
