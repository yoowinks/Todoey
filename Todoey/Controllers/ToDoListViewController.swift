//
//  ViewController.swift
//  Todoey
//
//  Created by Nam-Anh Vu on 1/14/18.
//  Copyright © 2018 TenTwelve. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    var toDoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name

        guard let colourHex = selectedCategory?.colour else { fatalError() }
        
        updateNavBar(withHexCode: colourHex)
    }


    override func willMove(toParentViewController parent: UIViewController?) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    // MARK: - NavBar Setup Methods
    func updateNavBar(withHexCode colourHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else { fatalError ("Navigation Controller does not exist.")}

        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        let contrastColour = ContrastColorOf(navBarColour, returnFlat: true)

        navBar.barTintColor = navBarColour
        navBar.tintColor = contrastColour
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: contrastColour]
        searchBar.barTintColor = navBarColour
        
        navBar.backgroundImage(for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
      
    }

    // MARK: - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
       
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    // MARK: - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error writing new Item \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Model manipulation methods
    
    func saveItems() {
    }
    
    func loadItems() {
    
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath, withAction: String) {
        
        if withAction == "Delete" {
            if let itemForDeletion = self.toDoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(itemForDeletion)
                        print("delete item - success")
                    }
                } catch {
                    print("error deleting item \(error)")
                }
                self.tableView.reloadData()
            }
        } else if withAction == "Edit" {
            
            if let itemForEdit = self.toDoItems?[indexPath.row] {

                var textField = UITextField()

                let alert = UIAlertController(title: "Edit the Item", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Save item", style: .default) { (action) in
                    
                    do {
                        try self.realm.write {
                        itemForEdit.title = textField.text!
                        }
                    } catch {
                        print("error deleting item \(error)")
                    }
                    
                    self.tableView.reloadData()
                }

                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Edit the item name"
                    alertTextField.text = itemForEdit.title
                    textField = alertTextField
                }

                alert.addAction(action)

                present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Search bar methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}








