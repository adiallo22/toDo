
//
//  SuperTableViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 2/4/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//
import UIKit
import SwipeCellKit
import AOModalStatus
import UserNotifications

class SuperTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var cell : UITableViewCell?
    
//    let center = UNUserNotificationCenter.current()
//    let contents = UNMutableNotificationContent()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(gradientStyle: .leftToRight, withFrame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height), andColors: [.flatWhite(), .flatGray()])
        //
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    
    //MARK: - data source delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
        
    }
    
    //MARK: - <#section heading#>
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                self.delete(at: indexPath)
            }
//        let modifyAction = SwipeAction(style: .default, title: "Modify") { (action, indexPath) in
//            print("modified...")
//        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
    //MARK: - delete
    
    func delete(at indexpath : IndexPath) {
        
    }
    
//    func modify(at indexpath : IndexPath) {
//
//    }
    
    func presentModalStatusView() {
        let modalView = AOModalStatusView(frame: self.view.bounds)
        modalView.set(headline: "Added")
        view.addSubview(modalView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
