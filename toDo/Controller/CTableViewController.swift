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
import ChameleonFramework
import AOModalStatus
//import Firebase

class CTableViewController: SuperTableViewController {
    
    var categories : Results<Category>?
    let realm = try! Realm()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.rowHeight = 78.0
        load()
//        navigationItem.titleView?.tintColor = .flatBlack()
    }
    
    

    //MARK: - action
    
    @IBAction func addToDo(_ sender: UIBarButtonItem) {
        
        var tobeAdded = UITextField()
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        alert.addTextField { (alert) in
            alert.placeholder = "Enter Category Title"
            tobeAdded = alert
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if tobeAdded.text == "" {
                return
            } else {
                self.createNewCathegory(tobeAdded)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    //ignore keyboard when touched outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
    
}


//MARK: - persistance


extension CTableViewController {
    
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
    
}

//MARK: - table view

extension CTableViewController {
    
    //data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
    
    //cellforrow
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let existCategory = categories?[indexPath.row] {
            guard let color = UIColor(hexString: existCategory.color) else {
                fatalError("no color")
            }
            cell.textLabel?.text = existCategory.name.uppercased()
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            cell.backgroundColor = color
        }
        return cell
        
    }
    

//MARK: - segues
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.goToList, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.goToList {
            let destinationVC = segue.destination as! TodoController
            if let indexpath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexpath.row]
            }
        }
        
    }
    
}


//MARK: - new category

extension CTableViewController {
    
    fileprivate func createNewCathegory(_ container: UITextField) {
        let newCategory = Category()
        newCategory.name = container.text!
        newCategory.color = UIColor.randomFlat().hexValue()
        self.tableView.reloadData()
        self.save(category: newCategory)
        self.presentModalStatusView()
    }
    
//    func signMeOut() {
//        if Auth.auth().currentUser != nil {
//            do {
//              try Auth.auth().signOut()
//            } catch let signOutError as NSError {
//              print ("Error signing out: %@", signOutError)
//            }
//        }
//        performSegue(withIdentifier: Constants.backToWelcome, sender: self)
//    }
    
}
