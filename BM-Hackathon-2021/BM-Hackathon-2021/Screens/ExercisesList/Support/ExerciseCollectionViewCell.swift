//
//  JourneyCardCollectionViewCell.swift
//  ARGame
//
//  Created by Andrii Halushka on 15.12.2020.
//  Copyright © 2020 BetterMe. All rights reserved.
//

import UIKit

class ExerciseCollectionViewCell: UICollectionViewCell {    
    // MARK: - @IBOutlets
    
    var onTap: (() -> Void)?
    
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func configure(title: String, imageName: String, onTap: @escaping () -> Void) {
        contentImageView.image = UIImage(named: imageName)
        titleLabel.text = title
        self.onTap = onTap
    }
    
    // MARK: - Actions
    
    @objc
    private func tapGestureHandler() {
        onTap?()
    }
    
    // MARK: - Private API
    
    private func setup() {
        contentView.layer.cornerRadius = 30
        contentView.clipsToBounds = true
        addTapGesture()
    }
    
    private func addTapGesture() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler)))
    }
}
