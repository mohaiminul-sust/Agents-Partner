//
//  CategoriesTableViewController.swift
//  Agents Partner
//
//  Created by Mohaiminul Islam on 5/18/16.
//  Copyright © 2016 infancyit. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesTableViewController: UITableViewController {
    
    let realm = try! Realm()
    lazy var categories: Results<Category> = { self.realm.objects(Category) }()
    var selectedCategory: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateDefaultCategories()
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
}

// MARK: - UITableViewDataSource

extension CategoriesTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath {
        selectedCategory = categories[indexPath.row]
        
        return indexPath
    }
    
    // MARK: - Helper Functions
    
    func populateDefaultCategories() {
        
        if categories.count == 0 {
            
            try! realm.write() {
                
                let defaultCategories = ["Birds", "Mammals", "Flora", "Reptiles", "Arachnids" ]
                
                for category in defaultCategories {
                    let newCategory = Category()
                    newCategory.name = category
                    self.realm.add(newCategory)
                }
            }
            
            categories = realm.objects(Category) // category updates here
        }
    }
}
