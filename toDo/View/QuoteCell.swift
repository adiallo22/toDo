//
//  QuoteCell.swift
//  toDo
//
//  Created by Abdul Diallo on 5/26/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var likes: UILabel!
    
    var count = 0
    
    var quote : Quote! {
        didSet {
            authorLabel.text = quote.author!
            quoteLabel.text = quote.quote!
            likes.text = "\(quote.likes)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likesClicked(_ sender: UIButton) {
        quote.likeCliked()
        likes.text = "\(quote.likes)"
    }
    

}
