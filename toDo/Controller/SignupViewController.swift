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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        errorLabel.alpha = 0
        db = Firestore.firestore()
        applyStyle()
        moveKepboardUp()
        fnameText.becomeFirstResponder()
        
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
                    UserDefaults.standard.set(email, forKey: Constants.Keys.email)
                    UserDefaults.standard.set(pwd, forKey: Constants.Keys.password)
                    self.transitionWelcome()
                }
            }
        }
    }
    
}

//MARK: - <#section heading#>

extension SignupViewController {
    
    func transitionWelcome() {
        let main : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = main.instantiateViewController(withIdentifier: "ToDoTabBar") as! ToDoTabBar
        UIApplication.shared.keyWindow?.rootViewController = viewController
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
    
    
    func applyStyle() {
        Style.styleTextField(pwdText)
        Style.styleTextField(emailText)
        Style.styleTextField(fnameText)
        Style.styleTextField(lnameText)
        Style.styleFilledButton(btn)
    }
    
}

//MARK: - keyboard

extension SignupViewController {
    
    func moveKepboardUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //dismiss keyboard when touch anywhere in screen
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
        @objc func keyboardWillShow(notification: NSNotification) {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= 100
                }
        }

        @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    
}

