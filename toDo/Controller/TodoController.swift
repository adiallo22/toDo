//
//  ViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 1/11/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit

class TodoController: UITableViewController {
    
    var things = [Item]()
    
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //if let items = defaults.array(forKey: "todoList") as? [String] {
        let newItem = Item()
        newItem.title = "demo"
        things.append(newItem)
        things.append(newItem)
        things.append(newItem)
        things.append(newItem)
        things.append(newItem)
        things.append(newItem)
    }
    
    //MARK: - table view data source protocol

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return things.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = things[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
        
    }
    
    //MARK: - table view delegate protocol
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            //change the property done whenever the user select the cell
            things[indexPath.row].done = !things[indexPath.row].done
           // tableView.reloadData()
           if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
              tableView.cellForRow(at: indexPath)?.accessoryType = .none
           } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
           }
           tableView.deselectRow(at: indexPath, animated: true)
        
       }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var toBeAdded = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item()
            newItem.title = toBeAdded.text!
            self.things.append(newItem)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alert) in
            alert.placeholder = "Enter item here"
            toBeAdded = alert
        }
        present(alert, animated: true, completion: nil)
        
    }
    
}



