//
//  AddNewItemVC.swift
//  toDo
//
//  Created by Abdul Diallo on 5/17/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit

class AddNewItemVC: UIViewController {

    @IBOutlet weak var ItemField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var dueDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleTheAddButton()
    }
    

    @IBAction func addPressed(_ sender: UIButton) {
        
    }
    

}

extension AddNewItemVC {
    
    func styleTheAddButton() {
        addBtn.layer.cornerRadius = 25.0
        addBtn.backgroundColor = .systemRed
    }
    
}
