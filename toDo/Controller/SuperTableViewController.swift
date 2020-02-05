//
//  SuperTableViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 2/4/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
import SwipeCellKit

class SuperTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var cell : UITableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - data source delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
        
    }
    
    //MARK: - <#section heading#>
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                self.delete(at: indexPath)
            }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
    //MARK: - delete
    
    func delete(at indexpath: IndexPath) {
        
    }

}
