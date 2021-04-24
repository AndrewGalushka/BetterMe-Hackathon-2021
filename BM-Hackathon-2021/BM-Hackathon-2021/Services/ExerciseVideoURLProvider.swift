//
//  ExercisesVideoURLProvider.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 23.04.2021.
//

import Foundation

class ExerciseVideoURLProvider {
    static let shared = ExerciseVideoURLProvider()
    private let videoURLs = ExerciseVideoURLProvider.loadURLs()
    private var currentRandomsIterator = ExerciseVideoURLProvider.loadURLs().shuffled().makeIterator()
    
    func nextURL() -> URL {
        if let next = currentRandomsIterator.next() {
            return next
        }
        
        var iterator = videoURLs.shuffled().makeIterator()
        let next = iterator.next()!
        self.currentRandomsIterator = iterator
        
        return next
    }
    
    private static func loadURLs() -> [URL] {
        
        return FileNames.allCases.map {
            let url = Bundle.main.url(forResource: $0.rawValue, withExtension: nil)!
            return url
        }
    }
    
    private enum FileNames: String, CaseIterable {
        case jumpingJacks = "jumping_jacks.mp4"
        case dancingRumba = "dancing_rumba.mp4"
        case lunges = "lunges.mp4"
    }
}
