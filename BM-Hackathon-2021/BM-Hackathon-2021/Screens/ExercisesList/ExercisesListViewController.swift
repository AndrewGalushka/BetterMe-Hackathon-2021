//
//  ExercisesListViewController.swift
//  BM-Hackathon-2021
//
//  Created Andrii Halushka on 24.04.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class ExercisesListViewController: UIViewController, UICollectionViewDataSource {
    typealias Item = (title: String, imageName: String)
    
    private let dataSource: [Item] = [
        (title: "Upper Body Explosion", "exr_1"),
        (title: "Training Bodyweight Only", "exr_2"),
        (title: "Upper Body Explosion", "exr_3"),
        (title: "Upper Body Explosion", "exr_4"),
        (title: "Upper Body Explosion", "exr_5")
    ]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
    }
    
    
    // sourcery: random
    struct Props: Equatable {
        let onDestroy: Command
        
        static let initial = Props(
            onDestroy: .nop
        )
    }
    
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}

extension ExercisesListViewController {
    class JourneysListFlowLayout: UICollectionViewFlowLayout {
        let desiredItemSize = CGSize(width: 340, height: 440)
        let itemAspectRatio = CGSize(width: 340, height: 440)
        
        override func prepare() {
            super.prepare()
            
            guard let collectionView = self.collectionView else {
                return
            }
            
            minimumLineSpacing = 1
            let vMargins: CGFloat = 20
            let hMargins: CGFloat = 20
            
            let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
            let availableHeight = collectionView.bounds.height
            let numberOfRows = collectionView.numberOfItems(inSection: 0)
            
            let itemWidth = min(desiredItemSize.width, availableWidth - hMargins)
            let itemHeight = (itemWidth == desiredItemSize.width) ? desiredItemSize.height
                : heightForWidth(itemWidth, withAspectRatio: itemAspectRatio)
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            
            let vSpacing = minimumLineSpacing * CGFloat(numberOfRows - 1)
            let hEdgeInset = max(hMargins, availableWidth - itemWidth - hMargins) / 2
            let vEdgeInset = max(vMargins, availableHeight - vSpacing - (itemHeight * CGFloat(numberOfRows))) / 2
            
            sectionInset = UIEdgeInsets(
                top: vEdgeInset,
                left: hEdgeInset,
                bottom: vEdgeInset,
                right: hEdgeInset
            )
        }
        
        private func heightForWidth(_ width: CGFloat, withAspectRatio: CGSize) -> CGFloat {
            width * withAspectRatio.height / withAspectRatio.width
        }
    }
}

