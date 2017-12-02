//
//  ModalTableViewController.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 1/8/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

import UIKit

class ModalCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    
}

protocol ModalOptions {
    func textFieldContent(of index: Int) -> String?
    func dismissModal()
    func present(alert: UIAlertController)
}

class ModalTableViewController: UITableViewController, UITextFieldDelegate, ModalOptions {
    enum CellButtonType {
        case `default`, cancel
    }
    
    class CellButton {
        var type: CellButtonType
        var title: String
        var handler: ((ModalOptions) -> ())?
        
        init(type: CellButtonType, title: String, handler: ((ModalOptions) -> ())?) {
            self.type = type
            self.title = title
            self.handler = handler
        }
    }
    
    class CellInput {
        var title: String
        var placeholder: String?
        var numerical: Bool
        var color: UIColor
        
        init(title: String, placeholder: String? = nil, numerical: Bool = false, color: UIColor = UIColor.black) {
            self.title = title
            self.placeholder = placeholder
            self.numerical = numerical
            self.color = color
        }
    }

    var modalTitle: String!
    var inputs: [CellInput]!
    var buttons: [CellButton]!
    
    var cellInputTextFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        navigationItem.title = modalTitle
    }
    
    func textFieldContent(of index: Int) -> String? {
        return cellInputTextFields[index].text
    }
    
    func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func present(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return inputs.count
        case 1:
            return buttons.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! ModalCell
            
            let input = inputs[indexPath.row]
            
            cell.titleLabel.text = input.title
            
            cell.inputField.textColor = input.color
            cell.inputField.placeholder = input.placeholder
            cell.inputField.delegate = self
            cell.inputField.keyboardType = input.numerical ? .numbersAndPunctuation : .default
            cell.inputField.autocapitalizationType = .sentences
            if indexPath.row == inputs.count-1 {
                cell.inputField.returnKeyType = .done
            } else {
                cell.inputField.returnKeyType = .next
            }
            if indexPath.row == 0 && cellInputTextFields.count == 0  {
                cell.inputField.becomeFirstResponder()
            }
            
            if cellInputTextFields.count <= indexPath.row {
                cellInputTextFields.append(cell.inputField)
            } else {
                cellInputTextFields[indexPath.row] = cell.inputField
            }
            
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
            
            let button = buttons[indexPath.row]
            
            //cell.textLabel?.textColor = button.type == .default ? view.tintColor : UIColor.red
            cell.textLabel?.font =  button.type == .default ? UIFont.systemFont(ofSize: 17) : UIFont.boldSystemFont(ofSize: 17)
            cell.textLabel?.text = button.title
            
            return cell
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section > 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let button = buttons[indexPath.row]
            
        button.handler?(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let index = cellInputTextFields.index(of: textField) else {
            return false
        }
        print(index)
        if index == cellInputTextFields.count-1 {
            textField.resignFirstResponder()
        } else {
            cellInputTextFields[index+1].becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let index = cellInputTextFields.index(of: textField) else {
            return true
        }
        
        if inputs[index].numerical {
            let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
            return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        }
        return true
    }

}
