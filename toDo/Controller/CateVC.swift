//
//  CateVC.swift
//  toDo
//
//  Created by Abdul Diallo on 5/26/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CateVC: SuperTableViewController {
    
    //@IBOutlet weak var tableView: UITableView!
    
    var things : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            load()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let barNav = navigationController?.navigationBar else {
            fatalError("navigation bar does not exist")
        }
        //sreachBar.barTintColor = view.backgroundColor
        navigationItem.title = selectedCategory?.name
    }
    
    //ignore keyboard when touched outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func load() {
        
        things = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }

}

extension CateVC {
    
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
