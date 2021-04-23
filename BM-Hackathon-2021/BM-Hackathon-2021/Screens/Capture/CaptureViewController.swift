//
//  CaptureViewController.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 23.04.2021.
//

import UIKit
import AVFoundation

class CaptureViewController: UIViewController {
    private let captureSession = Camera()
    private let capturePreview = CaptureVideoPreview()
    private let posesDetector = BodyDetector()
    private let debugView = PredictionTextResultsDebugView()
    private let overlayLayer = CAShapeLayer()
    private let pointsDisplayView = DetectedPointsDisplayView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession.configure()
        capturePreview.embed(to: view, safeArea: true)
        captureSession.bind(to: capturePreview.previewLayer)
        pointsDisplayView.embed(to: capturePreview)
        debugView.embed(to: view, safeArea: true)
        capturePreview.previewLayer.videoGravity = .resizeAspectFill
        
        captureSession.sampleBufferOutput = { [weak self] sampleBuffer in
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            
            self?.posesDetector.process(pixelBuffer: imageBuffer)
        }
        
        posesDetector.output = { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let poses):
                    self?.pointsDisplayView.show(detected: poses)
                case .failure(let error):
                    print("\(error)")
                    self?.pointsDisplayView.clear()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        captureSession.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stop()
    }
}
