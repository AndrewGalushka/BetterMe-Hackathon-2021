//
//  ActionClassifier.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 23.04.2021.
//

import Vision
import CoreML

class ActionPredictor {
    let classifier = GestureActionClassifier()
    let bodyPoseRequest = VNDetectHumanBodyPoseRequest()
    
    var posesWindow: [VNRecognizedPointsObservation?] = []
    
    init() {
        posesWindow.reserveCapacity(60)
    }
    
    func processFrame(_ buffer: CMSampleBuffer) throws -> [VNRecognizedPointsObservation] {
        let extracted = extractPoses(from: buffer)
        
        posesWindow.append(extracted.first)
        
        if posesWindow.count > 60 {
            posesWindow.removeFirst()
        }
        
        return extracted
    }
    
    func extractPoses(from sampleBuffer: CMSampleBuffer) -> [VNRecognizedPointsObservation] {
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        
        do {
            try handler.perform([bodyPoseRequest])
            return bodyPoseRequest.results ?? []
        } catch {
            return []
        }
    }
    
    typealias PredictionOutput = String
    
    var isReadyToMakePrediction: Bool {
        return posesWindow.count >= 60
    }
    
    func makePrediction() throws -> PredictionOutput {
        let poseMultiarray: [MLMultiArray] = try posesWindow.map { person in
            guard let person = person else {
                return try MLMultiArray(shape: [1,3,18], dataType: .float)
            }
            return try person.keypointsMultiArray()
        }
        
        let input = MLMultiArray(concatenating: poseMultiarray, axis: 0, dataType: .float)
        
        let predictions = try classifier.prediction(poses: input)
        
        posesWindow.removeAll()
        print("prediction made")
        
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
