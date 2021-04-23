//
//  PoseDetector.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 21.04.2021.
//

import Vision

class BodyPoseDetector {
    func process(pixelBuffer: CVPixelBuffer) {
        DispatchQueue.global().async {
            do {
                let request = VNDetectHumanBodyPoseRequest()
                let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
                try handler.perform([request])
                
                guard let humanBodyPoseObservations = request.results,
                      let firstBodyPoses = humanBodyPoseObservations.first else {
                    return
                }
                
//                let points = try poses.
//                    .filter { $0.value.confidence > 0.1 }
//                    .map { CGPoint(x: $0.value.location.x, y: 1 - $0.value.location.y) }
                
                self.log(firstBodyPoses.description)
            } catch let error {
                self.log(error.localizedDescription)
            }
        }
    }
    
    private func log(_ message: String) {
        DispatchQueue.global().async {
            print(message)
        }
    }
}
