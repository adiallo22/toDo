//
//  NewQuoteVC.swift
//  toDo
//
//  Created by Abdul Diallo on 5/28/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
import Firebase

class NewQuoteVC: UIViewController {

    @IBOutlet weak var ask: UILabel!
    @IBOutlet weak var quoteLabel: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    var db : DatabaseReference?
    var firestore : Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quoteLabel.delegate = self
        quoteLabel.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        db = Database.database().reference()
        firestore = Firestore.firestore()

        view.backgroundColor = UIColor.init(gradientStyle: .leftToRight, withFrame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height), andColors: [.flatWhite(), .flatGray()])
        
        styleBton()
        styleText()
    }
    
    //save quote in firestore
    @IBAction func postClicked(_ sender: UIButton) {
        guard let quote = quoteLabel.text, let uid = Auth.auth().currentUser?.uid else { fatalError("Field empty or no user signed in")}
        firestore!.document("users/\(uid)").getDocument { (doc, error) in
            if error != nil {
                print(error!)
            } else {
                let fn = doc!.get("first name")! as! String
                let ln = doc!.get("last name")! as! String
                self.ask.text = "Hey \(fn), What's on your mind ?"
                let newQuote = Quote.init(quote: quote, author: "\(fn) \(ln)")
                newQuote.saveToFirebase()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

//MARK: - <#section heading#>

extension NewQuoteVC {
    func styleBton() {
        Style.styleHollowButton(postBtn)
    }
}

//MARK: - textfield

extension NewQuoteVC : UITextViewDelegate {
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if quoteLabel.textColor == UIColor.lightGray {
                quoteLabel.text = nil
                quoteLabel.textColor = UIColor.black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if quoteLabel.text.isEmpty {
                quoteLabel.text = "What's happening ?"
                quoteLabel.textColor = UIColor.lightGray
            }
        }
        
        func setTextViewPlaceholder() {
            quoteLabel.text = "What's happening?"
            quoteLabel.textColor = UIColor.lightGray
        }
        
        //dismiss keyboard
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
        
        func styleText() {
            quoteLabel.backgroundColor = .white
            quoteLabel.layer.cornerRadius = 10.0
            quoteLabel.layer.borderWidth = 1.0
            quoteLabel.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
            setTextViewPlaceholder()
        }
}
