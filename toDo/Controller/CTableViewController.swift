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
        return cell
        
    }

    //MARK: - table view delegate
    
    //MARK: - section heading
    func save() {
        
        do {
            try context.save()
        } catch {
            print("error - \(error)")
        }
        tableView.reloadData()
        
    }
    
    func load(with request: NSFetchRequest<Category>){
        
        request = Category.fetchRequest()
        
        do {
            try context.fetch(request)
        } catch {
            print("error - \(error)")
        }
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
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            var newCategory = Category(context: self.context)
        }
        
        
    }
    
}
