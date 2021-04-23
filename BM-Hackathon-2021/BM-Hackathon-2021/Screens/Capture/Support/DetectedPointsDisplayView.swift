//
//  DetectedPointsDisplayView.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 23.04.2021.
//

import UIKit
import Vision

class DetectedPointsDisplayView: UIView {
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = self.bounds
    }
    
    func show(convertedPoints: [CGPoint]) {
        let pointsPath = UIBezierPath()
        
        for point in convertedPoints {
            pointsPath.move(to: point)
            pointsPath.addArc(withCenter: point, radius: 5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        }
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.path = pointsPath.cgPath
    }
    
    func clear() {
        shapeLayer.path = nil
    }
}

extension DetectedPointsDisplayView {
    func convertVisionPointsToUIKitCoordinates(_ visionPoint: CGPoint) -> CGPoint {
        CGPoint(x: visionPoint.x, y: 1 - visionPoint.y)
    }
    
    func convertRelativePoints(_ points: [CGPoint], intoRectWithSize size: CGRect) -> [CGPoint] {
        points.map { return VNImagePointForNormalizedPoint($0, Int(size.width), Int(size.height)) }
    }
}
