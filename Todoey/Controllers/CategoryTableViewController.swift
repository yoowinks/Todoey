//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Nam-Anh Vu on 1/15/18.
//  Copyright © 2018 TenTwelve. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm() // try! is a "code smell" but not always...
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatWhite()]
    }

    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
 
        if let category = categories?[indexPath.row] {
        
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colour) else { fatalError() }
                
            cell.backgroundColor = categoryColour 
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }

        return cell
    }
    
    // MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Add new Category method
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create category", style: .default) { (action) in
            
            // new NSManagedObject
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter a category name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data manipulation methods
    
    func save(category: Category) {

        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath, withAction: String) {

        if withAction == "Delete" {
            if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                        print("delete category - success")
                    }
                } catch {
                    print("error deleting Category \(error)")
                }
                self.tableView.reloadData()
            }
        } else if withAction == "Edit" {
            
            if let categoryForEdit = self.categories?[indexPath.row] {
            
                var textField = UITextField()
                
                let alert = UIAlertController(title: "Edit the Category", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Save category", style: .default) { (action) in
                    
                    try! self.realm.write {
                        categoryForEdit.name = textField.text!
                    }

                   self.tableView.reloadData()
                }
                
                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Edit the category name"
                    alertTextField.text = categoryForEdit.name
                    textField = alertTextField
                }
                
                alert.addAction(action)
                
                present(alert, animated: true, completion: nil)
            }
        }
    }
}

