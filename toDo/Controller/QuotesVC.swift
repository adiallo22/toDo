//
//  QuotesVC.swift
//  toDo
//
//  Created by Abdul Diallo on 5/26/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit
import Firebase

class QuotesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var quotes = [Quote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroundColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 107.0
        
        //fetch quotes from firestore
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchQuotes(from: Database.database().reference().child("quotes"))
    }
    
    func setBackgroundColor() {
        view.backgroundColor = UIColor.init(gradientStyle: .leftToRight, withFrame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height), andColors: [.flatWhite(), .flatGray()])
    }
    
    @IBAction func plusClicked(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.toNewQuote, sender: self)
    }
    
}

extension QuotesVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell") as! QuoteCell
        cell.quote = quotes[indexPath.row]
        cell.backgroundColor = UIColor.init(gradientStyle: .topToBottom, withFrame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height), andColors: [.flatWhite(), .flatGray()])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func fetchQuotes(from db : DatabaseReference) {
        db.observe(.value, with: { (snapshot) in
            self.quotes.removeAll()
            for child in snapshot.children {
                let childSnapPost = child as! DataSnapshot
                let quote = Quote.init(snapshot: childSnapPost)
                self.quotes.insert(quote, at: 0)
            }
            self.tableView.reloadData()
        })        
    }
    
}
