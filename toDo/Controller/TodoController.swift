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
        sreachBar.barTintColor = view.backgroundColor
        navigationItem.title = selectedCategory?.name
    }

    
    //MARK: - action
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: Constants.toNewItem, sender: self)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.toNewItem {
            let destVC = segue.destination as! AddNewItemVC
            destVC.delegate = self
        }
    }
    
}


//MARK: - load tableview

extension TodoController {
    
    func load() {
        
        things = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
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


//MARK: - new item delegate


extension TodoController : NewItemDelegate {
    
        func setInformation(date: Date, item: String) {
            if let curr = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = item
                        newItem.date = date
                        curr.items.append(newItem)
                    }
                    self.presentModalStatusView()
                } catch {
                    print("error - \(error)")
                }
            }
            tableView.reloadData()
        }
    
}


//MARK: - table view data source and delegate

extension TodoController {

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
    
}



