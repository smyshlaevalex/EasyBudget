//
//  ChartView.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 1/21/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

@objc protocol ChartViewDataSource {
    @objc var labelOffset: UIOffset { get }
    
    @objc var xAxisMax: Int { get }
    @objc var yAxisMax: Int { get }
    
    @objc var xLabelDistance: CGFloat { get }
    @objc var yLabelDistance: CGFloat { get }
    
    @objc optional func chartView(_ chartView: ChartView, labelForXaxis xAxis: Int) -> String
    @objc optional func chartView(_ chartView: ChartView, labelForYaxis yAxis: Int) -> String
    
    @objc var points: [CGPoint] { get }
    
    @objc optional var labelsColor: UIColor { get }
    @objc optional var lineColor: UIColor { get }
    
    @objc optional var lineWidth: CGFloat { get }
}

class ChartView: UIView, UIScrollViewDelegate {
    var dataSource: ChartViewDataSource?
    
    private weak var chartScrollView: ChartScrollView?
    private weak var chartLabelsView: ChartLabelsView?
    
    private var labelOffset = UIOffset.zero
    
    private var xAxisMax = 0
    private var yAxisMax = 0
    
    private var xLabelDistance: CGFloat = 0
    private var yLabelDistance: CGFloat = 0
    
    private var xZoom = 1.0
    private var yZoom = 1.0
    
    private var xAxisLabels = [String]()
    private var yAxisLabels = [String]()
    
    private var points = [CGPoint]()
    private var lineColor = UIColor.black
    private var lineWidth: CGFloat = 1
    
    private var labelsColor = UIColor.black
    
    override func awakeFromNib() {
        /*contentSize = CGSize(width: 1000, height: 1000)
        clipsToBounds = true*/
        
        
        //chartLines = ChartLinesView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        //chartLines?.initialize()
        
        //addSubview(chartLines!)
    }
    
    func createViews() {
        guard let dataSource = dataSource else {
            return
        }
        
        labelOffset = dataSource.labelOffset
        
        xAxisMax = dataSource.xAxisMax
        yAxisMax = dataSource.yAxisMax
        
        xLabelDistance = dataSource.xLabelDistance
        yLabelDistance = dataSource.yLabelDistance
        
        xAxisLabels = [String]()
        for i in 0..<xAxisMax {
            xAxisLabels.append(dataSource.chartView?(self, labelForXaxis: i) ?? String(i))
        }
        
        yAxisLabels = [String]()
        for i in 0..<yAxisMax {
            yAxisLabels.append(dataSource.chartView?(self, labelForYaxis: i) ?? String(i))
        }
        
        points = dataSource.points
        
        self.chartScrollView?.removeFromSuperview()
        self.chartLabelsView?.removeFromSuperview()
        
        let chartScrollView = ChartScrollView(frame: CGRect(x: labelOffset.horizontal, y: 0, width: bounds.width-labelOffset.horizontal, height: bounds.height-labelOffset.vertical))
        chartScrollView.delegate = self
        chartScrollView.initialize()
        
        self.chartScrollView = chartScrollView
        
        let chartLabelsView = ChartLabelsView(frame: bounds)
        chartLabelsView.chartSize = CGSize(width: bounds.width-labelOffset.horizontal, height: bounds.height-labelOffset.vertical)
        
        self.chartLabelsView = chartLabelsView
        
        addSubview(chartLabelsView)
        addSubview(chartScrollView)
        
        chartLabelsView.labelOffset = labelOffset
        chartLabelsView.xLabelDistance = xLabelDistance
        chartLabelsView.yLabelDistance = yLabelDistance
        
        chartScrollView.xLabelDistance = xLabelDistance
        chartScrollView.yLabelDistance = yLabelDistance
        chartScrollView.xAxisMax = xAxisMax
        chartScrollView.yAxisMax = yAxisMax
        
        chartScrollView.createViews()
        reloadData()
    }
    
    func reloadData() {
        guard let dataSource = dataSource else {
            return
        }
        
        xAxisLabels = [String]()
        for i in 0..<xAxisMax {
            xAxisLabels.append(dataSource.chartView?(self, labelForXaxis: i) ?? String(i))
        }
        
        yAxisLabels = [String]()
        for i in 0..<yAxisMax {
            yAxisLabels.append(dataSource.chartView?(self, labelForYaxis: i) ?? String(i))
        }
        
        points = dataSource.points
        lineColor = dataSource.lineColor ?? UIColor.black
        lineWidth = dataSource.lineWidth ?? 1
        
        labelsColor = dataSource.labelsColor ?? UIColor.black
        
        guard let chartLabelsView = chartLabelsView else {
            return
        }
        
        chartLabelsView.xAxisLabels = xAxisLabels
        chartLabelsView.yAxisLabels = yAxisLabels
        
        chartLabelsView.labelsColor = labelsColor
        
        chartLabelsView.setNeedsDisplay()
        
        guard let chartScrollView = chartScrollView else {
            return
        }
        
        chartScrollView.lineWidth = lineWidth
        chartScrollView.color = lineColor
        chartScrollView.points = points
        
        chartScrollView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        chartLabelsView?.chartScrollOffset = UIOffset(horizontal: offset.x, vertical: scrollView.contentSize.height-(offset.y+scrollView.bounds.height))
        reloadData()
    }
}
