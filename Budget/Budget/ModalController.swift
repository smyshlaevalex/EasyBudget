//
//  ModalController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 12/28/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class ModalController: UIViewController {
    var modalTitle: String!
    var inputs: [ModalTableViewController.CellInput]!
    var buttons: [ModalTableViewController.CellButton]!

    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "showModalContainerControllerSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "showModalContainerControllerSegue":
            let destination = segue.destination as! ModalContainerController
            
            destination.modalController = self
            
            destination.modalTitle = modalTitle
            destination.inputs = inputs
            destination.buttons = buttons
        default:
            break
        }
    }
    
    /*func containerHasBeenDismissed() {
        dismiss(animated: true, completion: nil)
    }*/
}
