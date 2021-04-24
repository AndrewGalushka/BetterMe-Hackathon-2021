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
    
    // MARK: - Props
    
    struct Props {
        let showPoints: Bool
        let showPredictions: Bool
        let onDetectedAction: CommandWith<ActionPredictor.Action>
        let onDestroy: Command
        
        static let initial = Props(
            showPoints: false,
            showPredictions: false,
            onDetectedAction: .nop,
            onDestroy: .nop
        )
    }
    private var props = Props.initial
    
    // MARK: - Private
    private let captureSession = Camera()
    private let capturePreview = CaptureVideoPreview()
    private let posesDetector = BodyDetector()
    private let textDebugView = PredictionTextResultsDebugView()
    private let overlayLayer = CAShapeLayer()
    private let pointsDisplayView = DetectedPointsDisplayView()
    private let actionPredictor = ActionPredictor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession.configure()
        capturePreview.embed(to: view, safeArea: false)
        captureSession.bind(to: capturePreview.previewLayer)
        pointsDisplayView.embed(to: capturePreview)
        textDebugView.embed(to: view, safeArea: true)
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
                        self?.textDebugView.display(text: "ERROR:\n\(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("\(error)")
                    self?.pointsDisplayView.clear()
                }
            }
        }
        
        actionPredictor.configure()
        actionPredictor.output = { [weak self] result in
            guard let strongSelf = self else { return }
            
            strongSelf.props.onDetectedAction.perform(with: result)
            strongSelf.showDebugOutput(for: result)
        }
    }
    
    deinit {
        props.onDestroy.perform()
    }
    
    func render(props: Props) {
        self.props = props
        
        if !props.showPoints {
            pointsDisplayView.clear()
        }
        
        if !props.showPredictions {
            textDebugView.display(text: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stop()
    }
    
    private func showDebugOutput(for action: ActionPredictor.Action) {
        guard props.showPredictions else {
            return
        }
        
        switch action.label {
        case .rightUp_Down:
            let highlightView = UIView(frame: view.bounds)
            highlightView.backgroundColor = nil
            self.view.addSubview(highlightView)
            
            UIView.animate(withDuration: 0.25) {
                highlightView.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
            } completion: { _ in
                highlightView.removeFromSuperview()
            }

        default:
            break
        }
        
        textDebugView.display(text: "\(action.label)")
    }
    
    private func passDetectedForDebug(_ detected: BodyDetector.OutputData) {
        guard props.showPoints else {
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
