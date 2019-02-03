//
//  PostsTableViewCell.swift
//  LeagueChallenge
//
//  Created by fernando marto on 2019-02-02.
//  Copyright © 2019 f. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postUserImage: UIImageView!
    @IBOutlet weak var postUserName: UIButton!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postText: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
