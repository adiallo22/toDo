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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("things.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
       load()
    }
    
    //MARK: - table view data source protocol

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return things.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        //retrieve data from the things @ current row and store it in item
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
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var toBeAdded = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alert) in
            alert.placeholder = "Enter item here"
            toBeAdded = alert
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item()
            newItem.title = toBeAdded.text!
            self.things.append(newItem)
            self.tableView.reloadData()
            self.save()
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func save() {
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(self.things)
            //write the data into our dataf file path
            try data.write(to: dataFilePath!)
        } catch {
            print("error : \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func load() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                things = try decoder.decode([Item].self, from: data)
            } catch {
                print("error : \(error)")
            }
        }
    }
    
}



