//
//  IntroViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 4/16/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
import Firebase

class IntroViewController: UIViewController {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    let auth = Auth.auth()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.alpha = 0
    }
    

    func checkError() -> String? {
        if emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pwdText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Fill in all the text field"
        }
        return nil
    }
    
    func setError(_ err: String) {
        errorLabel.text = err
        errorLabel.alpha = 1
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        let error = checkError()
        if error != nil {
            setError(error!)
        } else {
            auth.signIn(withEmail: emailText.text!, password: pwdText.text!) { (result, error) in
                if error != nil {
                    self.setError("Wrong email or Password")
                } else {
                    self.transitionTo(here: "signinToWelcome")
                }
            }
        }
        
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        transitionTo(here: "toSignup")
    }
    
    func transitionTo(here : String) {
        performSegue(withIdentifier: here, sender: self)
    }
    
}
