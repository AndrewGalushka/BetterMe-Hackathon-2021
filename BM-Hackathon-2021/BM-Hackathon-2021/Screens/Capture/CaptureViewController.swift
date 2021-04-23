//
//  CaptureViewController.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 23.04.2021.
//

import UIKit
import AVFoundation
import Vision

class CaptureViewController: UIViewController {
    // MARK: - Public
    var showPoints: Bool = false
    
    // MARK: - Private
    private let captureSession = Camera()
    private let capturePreview = CaptureVideoPreview()
    private let posesDetector = BodyDetector()
    private let debugView = PredictionTextResultsDebugView()
    private let overlayLayer = CAShapeLayer()
    private let pointsDisplayView = DetectedPointsDisplayView()
    private let actionPredictor = ActionPredictor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession.configure()
        capturePreview.embed(to: view, safeArea: true)
        captureSession.bind(to: capturePreview.previewLayer)
        pointsDisplayView.embed(to: capturePreview)
        debugView.embed(to: view, safeArea: true)
        capturePreview.previewLayer.videoGravity = .resizeAspectFill
        
        captureSession.sampleBufferOutput = { [weak self] in
            self?.posesDetector.process($0)
        }
        
        posesDetector.output = { result in
            DispatchQueue.main.async { [weak self] in
                self?.passDetectedForDebug(result)
                
                switch result {
                case .success(let poses):
                    do {
                        try self?.actionPredictor.processNext(poses)
                    } catch let error {
                        self?.debugView.display(text: "ERROR:\n\(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("\(error)")
                    self?.pointsDisplayView.clear()
                }
            }
        }
        
        actionPredictor.configure()
        actionPredictor.output = { [weak self] results in
            self?.debugView.display(text: results)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        captureSession.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stop()
    }
    
    private func passDetectedForDebug(_ detected: BodyDetector.OutputData) {
        guard showPoints else {
            return
        }
        
        do {
            guard let poses = try detected.get() else {
                pointsDisplayView.clear()
                return
            }
            
            let joints = try poses.recognizedPoints(.all)
            let convertedPoints = joints.values.map { joint -> CGPoint in
                let flippedPoint = CGPoint(x: joint.location.x, y: 1 - joint.location.y)
                return VNImagePointForNormalizedPoint(flippedPoint,
                                                      Int(self.pointsDisplayView.frame.width),
                                                      Int(self.pointsDisplayView.frame.height))
            }
            
            pointsDisplayView.show(convertedPoints: convertedPoints)
        } catch let error {
            print("\(error)")
            self.pointsDisplayView.clear()
        }
    }
}
