//
//  AddNewItemVC.swift
//  toDo
//
//  Created by Abdul Diallo on 5/17/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit

protocol NewItemDelegate {
    func setInformation(date: Date, item: String)
}

class AddNewItemVC: UIViewController {

    @IBOutlet weak var ItemField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var dueDate: UIDatePicker!
    
    var date : Date?
    
    var delegate : NewItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleTheAddButton()
    }
    

    @IBAction func addPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            guard let date = self.date else {
                print("No date picked")
                return
            }
            if let item = self.ItemField.text {
                self.delegate?.setInformation(date: date, item: item)
            } else {
                print("Item field cannot be empty")
            }
        }
    }
    @IBAction func datePicked(_ sender: UIDatePicker) {
        print("\(sender.date)")
        date = sender.date
    }
    

}

extension AddNewItemVC {
    
    func styleTheAddButton() {
        addBtn.layer.cornerRadius = 25.0
        addBtn.backgroundColor = .systemRed
        addBtn.tintColor = .black
    }
    
}
