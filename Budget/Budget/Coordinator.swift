//
//  Coordinator.swift
//  CoordinatorTest
//
//  Created by Alexander Smyshlaev on 6/17/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    
    var navigationController: UINavigationController { get }
    
    var presenter: UIViewController { get }
    var storyboard: UIStoryboard { get }
    
    func start()
}
