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
        
        if nameTextField.text!.isEmpty || descriptionTextField.text!.isEmpty || selectedCategory == nil {
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
    
    // MARK: - Add Specimen
    
    func addNewSpecimen(){
        let realm = try! Realm()
        
        try! realm.write {
            let newSpecimen = Specimen()
            
            newSpecimen.name = self.nameTextField.text!
            newSpecimen.category = self.selectedCategory
            newSpecimen.desc = self.descriptionTextField.text!
            newSpecimen.lat = self.selectedAnnotation.coordinate.latitude
            newSpecimen.lon = self.selectedAnnotation.coordinate.longitude
            
            realm.add(newSpecimen)
            
            self.specimen = newSpecimen
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
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if validateFields() {
            addNewSpecimen()
            return true
        } else {
            return false
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension AddNewEntryController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        performSegueWithIdentifier("Categories", sender: self)
    }
}

