//
//  SignupViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 4/16/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SignupViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var lnameText: UITextField!
    @IBOutlet weak var fnameText: UITextField!
    
    private let auth = Auth.auth()
    private var db : Firestore?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "SignUp"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        errorLabel.alpha = 0
        db = Firestore.firestore()
        
    }
    
    func checkError() -> String? {
        if emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pwdText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || fnameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lnameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Fill in all the text field"
        }
        return nil
    }
    
    func setError(_ err: String) {
        errorLabel.text = err
        errorLabel.alpha = 1
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        
        let error = checkError()
        if error != nil {
            setError(error!)
        } else {
            let fname = fnameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lname = lnameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pwd = pwdText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            auth.createUser(withEmail: email, password: pwd) { (result, error) in
                if error != nil {
                    self.setError("Could not sign you up")
                } else {
                    self.db?.collection("users").document("\(self.auth.currentUser!.uid)").setData(["first name":"\(fname)", "last name":"\(lname)", "email":"\(email)"])
                    self.performSegue(withIdentifier: "signupToWelcome", sender: self)
                }
            }

        }
        
    }
    
}
