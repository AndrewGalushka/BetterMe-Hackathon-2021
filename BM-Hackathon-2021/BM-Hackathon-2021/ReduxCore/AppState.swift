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
    var exerciseVideoState: ExerciseVideoState
    let exerciseVideoURL: URL
    
    static var initial: TrainingScreenState {
        return TrainingScreenState(
            exerciseVideoState: .maximised,
            exerciseVideoURL: ExerciseVideoURLProvider.shared.nextURL()
        )
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
            return state | {
                $0.exerciseVideoState = .maximised
            }
        case .maximised:
            return state | {
                $0.exerciseVideoState = .minimised
            }
        }
    default:
        return state
    }
}
