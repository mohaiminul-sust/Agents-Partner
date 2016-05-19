//
//  AddNewEntryController.swift
//  Agents Partner
//
//  Created by Mohaiminul Islam on 5/18/16.
//  Copyright © 2016 infancyit. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewEntryController: UIViewController {
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    var selectedAnnotation: SpecimenAnnotation!
    var selectedCategory: Category!
    var specimen: Specimen!
    
    //MARK: - Validation
    
    func validateFields() -> Bool {
        
        if nameTextField.text!.isEmpty || descriptionTextField.text!.isEmpty {
            let alertController = UIAlertController(title: "Validation Error", message: "All fields must be filled", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive) { alert in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(alertAction)
            presentViewController(alertController, animated: true, completion: nil)
            
            return false
            
        } else {
            return true
        }
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    @IBAction func unwindFromCategories(segue: UIStoryboardSegue) {
        if segue.identifier == "CategorySelectedSegue" {
            let categoriesController = segue.sourceViewController as! CategoriesTableViewController
            selectedCategory = categoriesController.selectedCategory
            categoryTextField.text = selectedCategory.name
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension AddNewEntryController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        performSegueWithIdentifier("Categories", sender: self)
    }
}

