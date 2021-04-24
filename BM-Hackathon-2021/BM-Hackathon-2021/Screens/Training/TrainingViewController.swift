//
//  TrainingViewController.swift
//  BM-Hackathon-2021
//
//  Created Andrii Halushka on 23.04.2021.
//  Copyright © 2021 Andrii Halushka. All rights reserved.
//

import UIKit

final class TrainingViewController: UIViewController {
    
    struct Props: Equatable {
        let exerciseVideoState: TrainingScreenState.ExerciseVideoState
        let onExerciseVideoTap: Command
        let onDestroy: Command
        
        static let initial = Props(
            exerciseVideoState: .maximised,
            onExerciseVideoTap: .nop,
            onDestroy: .nop
        )
    }
    private var props = Props.initial
    private var oldProps = Props.initial
    
    @IBOutlet var cameraContainer: UIView!
    @IBOutlet var exerciseVideoContainer: UIView!
    @IBOutlet var exerciseContainerMinWidthConstraint: NSLayoutConstraint!
    @IBOutlet var exerciseContainerMinHeightConstraint: NSLayoutConstraint!
    @IBOutlet var exerciseContainerMaxRightConstraint: NSLayoutConstraint!
    @IBOutlet var exerciseContainerMaxTopConstraint: NSLayoutConstraint!
    
    private lazy var cameraViewController = CaptureViewFactory().makeDefault()
    private lazy var exercisePlayerViewController = ExerciseVideoPlayerScreenFactory().makeDefault()
    
    deinit {
        props.onDestroy.perform()
    }
    
    func render(props: Props) {
        guard self.props != props else { return }
        self.props = props
        view.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateUI()
        oldProps = props
    }
    
    private func updateUI() {
        updateExerciseContainer()
    }
    
    private func updateExerciseContainer(force: Bool = false, animated: Bool = true) {
        if !force {
            guard props.exerciseVideoState != oldProps.exerciseVideoState else {
                return
            }
        }
        
        switch props.exerciseVideoState {
        case .minimised:
            NSLayoutConstraint.deactivate([
                exerciseContainerMaxRightConstraint,
                exerciseContainerMaxTopConstraint
            ])
            
            NSLayoutConstraint.activate([
                exerciseContainerMinWidthConstraint,
                exerciseContainerMinHeightConstraint
            ])
        case .maximised:
            NSLayoutConstraint.deactivate([
                exerciseContainerMinWidthConstraint,
                exerciseContainerMinHeightConstraint,
            ])
            
            NSLayoutConstraint.activate([
                exerciseContainerMaxRightConstraint,
                exerciseContainerMaxTopConstraint
            ])
        }
        
        
        UIView.animate(withDuration: animated ? 1 : 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setup() {
        cameraViewController.attach(to: self, in: cameraContainer, safeArea: false)
        cameraViewController.view.isUserInteractionEnabled = false
        
        exerciseVideoContainer.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onExerciseVideoTap))
        )
        
        exercisePlayerViewController.attach(to: self, in: exerciseVideoContainer)
        exerciseVideoContainer.clipsToBounds = true
        exerciseVideoContainer.layer.cornerRadius = 32
        updateExerciseContainer(force: true, animated: false)
    }
    
    @objc
    private func onExerciseVideoTap() {
        props.onExerciseVideoTap.perform()
    }
    
    @IBAction func onGearTap(_ sender: Any) {
        present(SettingsScreenFactory().makeDefault(),
                animated: true,
                completion: nil)
    }
}

// MARK: - Private methods
private extension TrainingViewController {
    
}
