//
//  ActionClassifier.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 23.04.2021.
//

import Vision
import CoreML

extension ActionPredictor {
    struct Action {
        let label: LabelType
        let confidence: Double
    }
    
    enum LabelType: String, CaseIterable {
        case rightUp_Down
        case swipe_right_to_left
        case swipe_up
        case other
        case resting
        case none
        
        init?(name: String) {
            guard let action = LabelType.allCases.first(where: {
                $0.name == name
            }) else { return nil }
            
            self = action
        }
        
        var name: String {
            switch self {
            case .rightUp_Down:
                return "Up right to left"
            case .other:
                return "Other"
            case .resting:
                return "Resting"
            case .none:
                return "None"
            case .swipe_right_to_left:
                return "Swipe right to left"
            case .swipe_up:
                return "Bottom to top"
            }
        }
    }
}

class ActionPredictor {
    // MARK: - Public
    
    typealias Output = ActionPredictor.Action
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
        
        guard let first = predictions.labelProbabilities.sorted(by: { (a,b) in a.value > b.value }).first,
              first.value > 0.2 else {
            return .init(label: .none, confidence: 100)
        }
        
        return convertLabelProbabilityToAction(name: first.key, probability: first.value)
    }
     
    private func convertLabelProbabilityToAction(name: String, probability: Double) -> ActionPredictor.Action {
        guard let actionType = ActionPredictor.LabelType(name: name) else {
            return ActionPredictor.Action(label: .none, confidence: 1)
        }
        
        return ActionPredictor.Action(label: actionType, confidence: probability)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
