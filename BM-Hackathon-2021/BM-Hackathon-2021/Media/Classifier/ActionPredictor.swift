//
//  ActionClassifier.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 23.04.2021.
//

import Vision
import CoreML

class ActionPredictor {
    // MARK: - Public
    
    typealias Output = String
    var output: ((Output) -> Void)?
    
    // MARK: - Private
    
    private var classifier: GestureActionClassifier!
    private var posesWindow: [VNRecognizedPointsObservation?] = []
    
    /// Prediction window duration, measured in seconds.
    private let predictionWindowDuration: TimeInterval = 1.5
    
    /// Number of frames in one prediction window
    private let predictionWindowFrames: Int = 45
    private let framesPerSecond = 30
    
    init() {
        posesWindow.reserveCapacity(predictionWindowFrames)
    }
    
    func configure() {
        let config = MLModelConfiguration()
        
        GestureActionClassifier.load(configuration: config, completionHandler: { [weak self] (result) in
            switch result {
            case .success(let classifier):
                self?.classifier = classifier
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        })
    }
    
    func processNext(_ bodyPose: VNHumanBodyPoseObservation?) throws {
        if posesWindow.count >= predictionWindowFrames {
            posesWindow.removeFirst()
        }
        
        posesWindow.append(bodyPose)
        
        if isReadyToMakePrediction {
            let results = try makePrediction()
            output?(results)
        }
    }
    
    var isReadyToMakePrediction: Bool {
        return posesWindow.count >= predictionWindowFrames
    }
    
    private func makePrediction() throws -> Output {
        let poseMultiArray: [MLMultiArray] = try posesWindow.map { person in
            guard let person = person else {
                return try MLMultiArray(shape: [1, 3, 18], dataType: .double)
            }
            return try person.keypointsMultiArray()
        }
        
        let input = MLMultiArray(concatenating: poseMultiArray, axis: 0, dataType: .float)
        let predictions = try classifier.prediction(poses: input)
        
        return predictions.labelProbabilities.sorted(by: { (a,b) in a.key > b.key }).map { "\($0.key): \(($0.value * 100).rounded(toPlaces: 2))%" }.joined(separator: "\n")
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
