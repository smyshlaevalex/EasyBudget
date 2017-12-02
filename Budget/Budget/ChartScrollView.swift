//
//  ChartScrollView.swift
//  ChartViewTest
//
//  Created by Alexander Smyshlaev on 2/15/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class ChartScrollView: UIScrollView {
    weak var chartLineView: ChartLineView?
    
    var xLabelDistance: CGFloat = 0
    var yLabelDistance: CGFloat = 0
    
    var xZoom = 1.0
    var yZoom = 1.0
    
    var xAxisMax = 0
    var yAxisMax = 0
    
    var points = [CGPoint]()
    var color = UIColor.black
    var lineWidth: CGFloat = 1
    
    func initialize() {
        clipsToBounds = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        bounces = false
    }
    
    func createViews() {
        self.chartLineView?.removeFromSuperview()
        
        let chartRect = CGRect(x: 0, y: 0, width: xLabelDistance*CGFloat(xAxisMax), height: max((yLabelDistance*CGFloat(yAxisMax)), bounds.height))
        
        let chartLineView = ChartLineView(frame: chartRect)
        self.chartLineView = chartLineView
        addSubview(chartLineView)
        
        contentSize = chartRect.size
        
        contentOffset.y = contentSize.height-bounds.height
    }
    
    func reloadData() {
        guard let chartLineView = chartLineView else {
            return
        }
        
        chartLineView.points = points
        chartLineView.color = color
        chartLineView.lineWidth = lineWidth
        
        chartLineView.reloadData()
    }
}
