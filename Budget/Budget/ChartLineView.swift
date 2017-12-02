//
//  ChartLineView.swift
//  ChartViewTest
//
//  Created by Alexander Smyshlaev on 2/15/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class ChartLineView: UIView {
    var points = [CGPoint]() {
        didSet {
            reloadData()
        }
    }
    
    var color = UIColor.black
    var lineWidth: CGFloat = 1
    
    func reloadData() {
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        points.sort { $0.x < $1.x }
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(UIColor.white.cgColor)
        context.fill(bounds)
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        
        var isContextSetup = false
        
        for point in points {
            let convertedPoint = CGPoint(x: point.x, y: bounds.height-point.y)
            
            if !isContextSetup {
                context.move(to: convertedPoint)
                isContextSetup = true
            } else {
                context.addLine(to: convertedPoint)
            }
        }
        
        context.strokePath()
    }
}
