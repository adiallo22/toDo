//
//  ViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 1/11/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
import CoreData

class TodoController: UITableViewController {
    
    var things = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        load()
        
    }
    
    //MARK: - table view data source protocol

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return things.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        //retrieve data from the things @ current row
        let item = things[indexPath.row]
        //insert title of item in the cell
        cell.textLabel?.text = item.title
        //cell.accessoryType = item.done ? .checkmark : .none
        return cell
        
    }
    
    //MARK: - table view delegate protocol
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            //change the property done whenever the user select the cell
            things[indexPath.row].done = !things[indexPath.row].done
            save()
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            tableView.deselectRow(at: indexPath, animated: true)
        
       }
    
    //MARK: - action
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var toBeAdded = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alert) in
            alert.placeholder = "Enter item here"
            toBeAdded = alert
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = toBeAdded.text!
            newItem.done = false
            self.things.append(newItem)
            self.tableView.reloadData()
            self.save()
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - <#section heading#>
    
    func save() {
        
        do {
            try context.save()
        } catch {
            print("error : \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func load(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            things = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("error - \(error)")
        }
        
    }
    
}

//MARK: - search bar

extension TodoController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        load(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            load()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
}



