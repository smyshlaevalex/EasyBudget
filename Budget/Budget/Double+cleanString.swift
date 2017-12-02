//
//  Double+cleanString.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 2/17/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import Foundation

fileprivate struct Formatter {
    static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        
        return formatter
    }()
    
    private init() {}
}

extension Double {
    var cleanString: String {
        let formatter = Formatter.formatter
        
        return formatter.string(from: NSNumber(value: self))!
    }
}
