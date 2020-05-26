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
    @IBOutlet weak var errorLabel: UILabel!
    
    var date : Date?
    var delegate : NewItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleTheAddButton()
        errorLabel.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ItemField.resignFirstResponder()
        view.backgroundColor = UIColor.init(gradientStyle: .leftToRight, withFrame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height), andColors: [.flatWhite(), .flatGray()])
    }
    

    @IBAction func addPressed(_ sender: UIButton) {
        
        let error = checkForError()
        if error != nil {
            setError(error!)
        } else {
            guard let date = self.date else {
                self.setError("No date picked")
                return
            }
            self.dismiss(animated: true) {
                self.delegate?.setInformation(date: date, item: self.ItemField.text!)
            }
        }
    }
    
    @IBAction func datePicked(_ sender: UIDatePicker) {
        date = sender.date
    }
    
    //ignore keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           view.endEditing(true)
    }
    
    func checkForError() -> String? {
        if ItemField.text == "" {
            return "Insert new item before adding"
        }
        return nil
    }
    
    func setError(_ error : String) {
        self.errorLabel.text = error
        self.errorLabel.alpha = 1.0
    }
    

}


//MARK: - style

extension AddNewItemVC {
    
    func styleTheAddButton() {
        addBtn.layer.cornerRadius = 25.0
        addBtn.backgroundColor = .systemRed
        addBtn.tintColor = .black
    }
    
}
