//
//  SettingsViewController.swift
//  BM-Hackathon-2021
//
//  Created Andrii Halushka on 24.04.2021.
//  Copyright © 2021 Andrii Halushka. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    struct Props: Equatable {
        let isPredictionsOn: Bool
        let isPointsOn: Bool
        let onShowPredictionChange: CommandWith<Bool>
        let onShowPointsChange: CommandWith<Bool>
        let onDestroy: Command
        
        static let initial = Props(
            isPredictionsOn: false,
            isPointsOn: false,
            onShowPredictionChange: .nop,
            onShowPointsChange: .nop,
            onDestroy: .nop
        )
    }
    
    @IBOutlet var showPointsSwitch: UISwitch!
    @IBOutlet var showPredictionsSwitch: UISwitch!
    
    private var props = Props.initial
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showPointsSwitch.isOn = props.isPointsOn
        showPredictionsSwitch.isOn = props.isPredictionsOn
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func onShowPointsFlagChanged(_ sender: UISwitch) {
        props.onShowPointsChange.perform(with: sender.isOn)
    }
    
    @IBAction func onShowPredictionsFlagChanged(_ sender: UISwitch) {
        props.onShowPredictionChange.perform(with: sender.isOn)
    }
    
    @IBAction func onDoneTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private methods
private extension SettingsViewController {
    
}
