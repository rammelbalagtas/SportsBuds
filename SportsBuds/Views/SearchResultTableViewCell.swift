//
//  SeaerchResultTableViewCell.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-30.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBAction func addToFavorites(_ sender: UIButton) {
    }
    
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
