//
//  CTableViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 1/28/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CTableViewController: UITableViewController {
    
    var categories : Results<Category>?
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let realm = try! Realm()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        load()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cathegoryCell", for: indexPath)
        let cathegory = categories?[indexPath.row]
        cell.textLabel?.text = cathegory?.name ?? "Empty Category"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cathegoryCell")
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
        self.tableView.reloadData()
        
    }
    
    func load() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
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
