//
//  PoseDetector.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 21.04.2021.
//

import Vision

class BodyDetector: NSObject {
    typealias OutputData = Result<VNHumanBodyPoseObservation?, Error>
    var output: ((OutputData) -> Void)?
    
    func process(_ sampleBuffer: CMSampleBuffer) {
        DispatchQueue.global().async {
            do {
                let request = VNDetectHumanBodyPoseRequest()
                let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer)
                try handler.perform([request])
                
                guard let humanBodyPoseObservations = request.results,
                      let firstBodyPoses = humanBodyPoseObservations.first else {
                    self.output?(.success(nil))
                    return
                }
                
                self.output?(.success(firstBodyPoses))
            } catch let error {
                self.output?(.failure(error))
            }
        }
    }
    
    private func log(_ message: String) {
        DispatchQueue.global().async {
            print(message)
        }
    }
}
