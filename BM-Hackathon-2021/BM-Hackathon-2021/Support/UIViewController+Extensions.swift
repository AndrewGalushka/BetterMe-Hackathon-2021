//
//  UIViewController+Extensions.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import UIKit

extension UIViewController {
    static func loadFromStoryboard() -> Self {
        return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self)).instantiateInitialViewController() as! Self
    }
    
    func attach(to parentVC: UIViewController) {
        attach(to: parentVC, in: parentVC.view)
    }
    
    func attach(to parentVC: UIViewController, in parentView: UIView, position: Int? = nil, inset: UIEdgeInsets = .zero, safeArea: Bool = true) {
        self.willMove(toParent: parentVC)
        
        view.embed(to: parentView, position: position, inset: inset, safeArea: safeArea)
        
        parentVC.addChild(self)
        self.didMove(toParent: parentVC)
    }
}
