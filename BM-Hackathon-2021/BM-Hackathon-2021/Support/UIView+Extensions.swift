//
//  UIView+Extensions.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import UIKit

extension UIView {
    func embed(to superview: UIView, position: Int? = nil, inset: UIEdgeInsets = .zero, safeArea shouldRespectSafeArea: Bool = false) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let position = position {
            superview.insertSubview(self, at: position)
        } else {
            superview.addSubview(self)
        }
        
        
        if shouldRespectSafeArea {
            NSLayoutConstraint.activate([
                self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -inset.bottom),
                self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: inset.top),
                self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: inset.left),
                self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -inset.right)
            ])
        } else {
            NSLayoutConstraint.activate([
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset.bottom),
                self.topAnchor.constraint(equalTo: superview.topAnchor, constant: inset.top),
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset.left),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset.right)
            ])
        }
    }
    
    func embed(to superview: UIView, insetBy: CGFloat, safeArea shouldRespectSafeArea: Bool = false) {
        embed(
            to: superview,
            inset: UIEdgeInsets(top: insetBy, left: insetBy, bottom: insetBy, right: insetBy),
            safeArea: shouldRespectSafeArea
        )
    }
}
