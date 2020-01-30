//
//  CTableViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 1/28/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
import CoreData

class CTableViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        
        super.viewDidLoad()
        load()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cathegoryCell", for: indexPath)
        let cathegory = categories[indexPath.row]
        cell.textLabel?.text = cathegory.name
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
            destinationVC.selectedCategory = categories[indexpath.row]
        }
    }
    
    
    //MARK: - section heading
    func save() {
        
        do {
            try context.save()
        } catch {
            print("error : \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func load(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("error - \(error)")
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
            let newCategory = Category(context: self.context)
            newCategory.name = tobeAdded.text
            self.categories.append(newCategory)
            self.tableView.reloadData()
            self.save()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
