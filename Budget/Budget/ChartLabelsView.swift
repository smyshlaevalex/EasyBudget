//
//  ChartLabelsView.swift
//  ChartViewTest
//
//  Created by Alexander Smyshlaev on 2/15/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class ChartLabelsView: UIView {
    var chartScrollOffset = UIOffset.zero
    
    var labelOffset = UIOffset.zero
    
    var xLabelDistance: CGFloat = 0
    var yLabelDistance: CGFloat = 0
    
    var xZoom = 1.0
    var yZoom = 1.0
    
    var xAxisLabels = [String]()
    var yAxisLabels = [String]()
    
    var chartSize = CGSize.zero
    
    var labelsColor: UIColor = UIColor.black
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(UIColor.white.cgColor)
        context.fill(bounds)
        
        let (xLabels, xStartOffset) = labelsAndStartOffsetForXaxis()
        
        for (index, label) in xLabels.enumerated() {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            (label as NSString).draw(at: CGPoint(x: labelOffset.horizontal+xStartOffset+CGFloat(index)*xLabelDistance, y: bounds.height-labelOffset.vertical/2), withAttributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.foregroundColor: labelsColor])
        }
        
        let (yLabels, yStartOffset) = labelsAndStartOffsetForYaxis()
        
        for (index, label) in yLabels.enumerated() {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            (label as NSString).draw(at: CGPoint(x: 0, y: bounds.height-(labelOffset.vertical+yStartOffset+CGFloat(index)*yLabelDistance)), withAttributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.foregroundColor: labelsColor])
        }
    }
    
    func labelsAndStartOffsetForXaxis() -> (labels: ArraySlice<String>, startOffset: CGFloat) {
        let startLabelIndex = max(Int(ceil(chartScrollOffset.horizontal/xLabelDistance)), 0)
        
        let endLabelIndex = min(startLabelIndex + Int(chartSize.width/xLabelDistance), xAxisLabels.count-1)
        
        let rangeOfLabels = xAxisLabels[startLabelIndex...endLabelIndex]
        
        var offsetForLabels = xLabelDistance-chartScrollOffset.horizontal.truncatingRemainder(dividingBy: xLabelDistance)
        if startLabelIndex == 0 {
            offsetForLabels = 0
        }
        
        return (rangeOfLabels, offsetForLabels)
    }
    
    func labelsAndStartOffsetForYaxis() -> (labels: ArraySlice<String>, startOffset: CGFloat) {
        let startLabelIndex = max(Int(ceil(chartScrollOffset.vertical/yLabelDistance)), 0)
        
        let endLabelIndex = min(startLabelIndex + Int(chartSize.height/yLabelDistance), yAxisLabels.count-1)
        
        let rangeOfLabels = yAxisLabels[startLabelIndex...endLabelIndex]
        
        var offsetForLabels = yLabelDistance-chartScrollOffset.vertical.truncatingRemainder(dividingBy: yLabelDistance)
        if startLabelIndex == 0 {
            offsetForLabels = 0
        }
        
        return (rangeOfLabels, offsetForLabels)
    }
}
