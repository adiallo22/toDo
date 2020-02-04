//
//  ViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 1/11/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
import RealmSwift

class TodoController: UITableViewController {
    
    var things : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            load()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    //MARK: - table view data source protocol

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return things?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        if let item = things?[indexPath.row] {
            cell.textLabel?.text = item.title
        } else {
            cell.textLabel?.text = "No Item"
        }
        return cell
        
    }
    
    //MARK: - table view delegate protocol
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
            if let curr = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = toBeAdded.text!
                        curr.items.append(newItem)
                    }
                } catch {
                    print("error - \(error)")
                }
                
            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - <#section heading#>
    
    //func save(item: Item) {
        
        //do {
            //try realm.write {
                //realm.add(item)
            //}
       // } catch {
          //  print("error : \(error)")
       // }
        //self.tableView.reloadData()
   // }
    
    func load() {
        
        things = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
}

//MARK: - search bar
/*

extension TodoController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        load(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            load()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
}*/



