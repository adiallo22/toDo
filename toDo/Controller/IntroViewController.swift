//
//  IntroViewController.swift
//  toDo
//
//  Created by Abdul Diallo on 4/16/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class IntroViewController: UIViewController {

    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    private let auth = Auth.auth()
    
   // let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Welcome"
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        errorLabel.alpha = 0
        applyStyle()
        setAutomaticLogin()
        
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
                    self.transitionTo(here: "")
                }
            }
        }
        
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        transitionTo(here: Constants.toSignup)
    }
    
    func setAutomaticLogin() {
        if let email = UserDefaults.standard.string(forKey: Constants.Keys.email), let password = UserDefaults.standard.string(forKey: Constants.Keys.password) {
            print(email)
            emailText.text = "\(email)"
            pwdText.text = "\(password)"
        }
    }
    
}

//MARK: - <#section heading#>

extension IntroViewController {
    
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
    
    
    func transitionTo(here : String) {
        if here == "" {
            let main : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = main.instantiateViewController(withIdentifier: "ToDoTabBar") as! ToDoTabBar
            UIApplication.shared.keyWindow?.rootViewController = viewController
        } else {
            performSegue(withIdentifier: here, sender: self)
        }
    }
    
    
    func applyStyle() {
        
        Style.styleHollowButton(btn)
        Style.styleFilledButton(signupBtn)
        Style.styleTextField(pwdText)
        Style.styleTextField(emailText)
        signupBtn.tintColor = .flatPurpleDark()
        
    }
    
    
    //dismiss keyboard when touch anywhere in screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
