//
//  ExercisesVideoURLProvider.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 23.04.2021.
//

import Foundation

class ExerciseVideoURLProvider {
    static let shared = ExerciseVideoURLProvider()
    private let videoURLs = [FileNames.allCases]
    
    func nextURL() -> URL {
        let url = Bundle.main.url(forResource: FileNames.allCases.randomElement()!.rawValue, withExtension: nil)!
        return url
    }
    
    private enum FileNames: String, CaseIterable {
        case jumpingJacks = "jumping_jacks.mp4"
        case dancingRumba = "dancing_rumba.mp4"
    }
}
