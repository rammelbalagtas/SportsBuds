//
//  MyFavTableViewCell.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-09.
//

import UIKit

class MyFavTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(using post: PostApi) {
        self.nameLabel.text = post.title
    }
    
}
