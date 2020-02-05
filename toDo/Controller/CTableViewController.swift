//
//  CTableViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 1/28/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CTableViewController: SuperTableViewController {
    
    var categories : Results<Category>?
    let realm = try! Realm()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.rowHeight = 78.0
        load()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
    
    //cellforrow
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Empty Category"
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return cell
        
    }

    //MARK: - table view delegate
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexpath.row]
        }
    }
    
    
    //MARK: - section heading
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error : \(error)")
        }
        tableView.reloadData()
        
    }
    
    func load() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    override func delete(at indexPath : IndexPath) {
        if let tobedeleted = self.categories?[indexPath.row] {
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

    //MARK: - action

    @IBAction func addToDo(_ sender: UIBarButtonItem) {
        
        var tobeAdded = UITextField()
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        alert.addTextField { (alert) in
            alert.placeholder = "Enter Category"
            tobeAdded = alert
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = tobeAdded.text!
            //self.categories.append(newCategory)
            self.tableView.reloadData()
            self.save(category: newCategory)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
