//
//  TutorialViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 2/25/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    weak var tutorialPageViewController: TutorialPageViewController!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var dismissButton: UIButton!
    
    var image: UIImage?
    var text: String?
    var pageIndex = 0
    var isLastViewController = false
    
    override func viewWillAppear(_ animated: Bool) {
        dismissButton.backgroundColor = UIColor.clear
        dismissButton.tintColor = UIColor.flatMintDark
        
        if !isLastViewController {
            imageView.image = image
            label.text = text
        } else {
            imageView.isHidden = true
            label.isHidden = true
            dismissButton.isHidden = false
        }
        
    }
    
    @IBAction func dissmissTutorial(_ sender: UIButton) {
        tutorialPageViewController.dismiss(animated: true, completion: nil)
    }
}
