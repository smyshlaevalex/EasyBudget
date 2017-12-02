//
//  TutorialBlurViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 2/25/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class TutorialBlurViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performSegue(withIdentifier: "showPageViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TutorialPageViewController
        
        destination.tutorialBlurViewController = self
    }
}
