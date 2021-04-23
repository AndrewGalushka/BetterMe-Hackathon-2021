//
//  PredictionTextResultsDebugView.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 23.04.2021.
//

import UIKit

class PredictionTextResultsDebugView: UIView {
    private let label = UILabel()
    
    func display(text: String) {
        self.label.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        label.embed(to: self, insetBy: 16, safeArea: true)
        label.textAlignment = .center
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
    }
}
