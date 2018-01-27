//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Nam-Anh Vu on 1/17/18.
//  Copyright © 2018 TenTwelve. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
    }
  
    
    // TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
                
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath, withAction: "Delete")
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { ( action, indexPath) in
            self.updateModel(at: indexPath, withAction: "Edit")
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        editAction.backgroundColor = UIColor.flatSkyBlue
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        
        options.expansionStyle = .none
        
        return options
    }
    
    func updateModel(at indexPath: IndexPath, withAction: String) {
        
    }
}
    
    
    


   
    

