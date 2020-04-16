//
//  ViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 1/11/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework
import AOModalStatus
import Firebase

class TodoController: SuperTableViewController {
    
    @IBOutlet weak var sreachBar: UISearchBar!
    
    var things : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            load()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.rowHeight = 78.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let barNav = navigationController?.navigationBar else {
            fatalError("navigation bar does not exist")
        }
        sreachBar.barTintColor = barNav.barTintColor
        navigationItem.title = selectedCategory?.name
    }
    
    //MARK: - table view data source protocol

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return things?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = things?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(Float(indexPath.row)/Float(things!.count))) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No Item"
        }
        return cell
        
    }
    
    //MARK: - table view delegate protocol
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try realm.write {
                if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                    tableView.cellForRow(at: indexPath)?.accessoryType = .none
                } else {
                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                }
            }
        } catch {
            print("error - \(error)")
        }
        tableView.reloadData()
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
                        newItem.date = Date()
                        curr.items.append(newItem)
                    }
                    self.presentModalStatusView()
                } catch {
                    print("error - \(error)")
                }
                
            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func load() {
        
        things = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
    override func delete(at indexPath : IndexPath) {
        if let tobedeleted = self.things?[indexPath.row] {
          do {
              try self.realm.write {
                  self.realm.delete(tobedeleted)
              }
          } catch{
              print("error deleting - \(error)")
          }
          tableView.reloadData()
          }
    }
    
}

//MARK: - search bar

extension TodoController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        things = things?.filter("title CONTAINS[cd] %@", searchBar.text!)
        things?.sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
        
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



