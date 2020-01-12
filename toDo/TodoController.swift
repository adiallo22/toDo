//
//  ViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 1/11/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit

class TodoController: UITableViewController {
    
    let things = ["go to gym", "make $$", "enjoy my bday", "work on my project", "cook"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - table view data source protocol

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return things.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = things[indexPath.row]
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

}



