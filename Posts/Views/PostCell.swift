//
//  PostCell.swift
//  Posts
//
//  Created by Luis Sergio Duran Arenas on 12/10/23.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblBody: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
