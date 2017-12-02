//
//  Transaction.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 12/14/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import Foundation

struct Transaction {
    var id: Int64?
    var name: String
    var money: Double
    var date: Date
    
    init(id: Int64? = nil, name: String, money: Double, date: Date) {
        self.id = id
        self.name = name
        self.money = money
        self.date = date
    }
}
