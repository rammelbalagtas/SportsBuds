//
//  SeaerchResultTableViewCell.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-30.
//

import UIKit

protocol SearchResultTableCell {
    func addToFavorites(id: Int)
    func removeFromFavorites(id: Int)
}

class SearchResultTableViewCell: UITableViewCell {
    
    var delegate: SearchResultTableCell!
    var post: Post!
    var isFav: Bool!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBAction func addRemoveFavorites(_ sender: UIButton) {
        if self.isFav {
            self.isFav.toggle()
            self.favoritesButton.titleLabel?.text = "Add To Favorites"
            self.delegate.removeFromFavorites(id: post.id)
        } else {
            self.isFav.toggle()
            self.favoritesButton.titleLabel?.text = "Remove From Favorites"
            self.delegate.addToFavorites(id: post.id)
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
    
    func configureCell(using post: Post, emailAddress: String, isFav: Bool) {
        self.post = post
        self.postTitleLabel.text = post.title
        self.locationLabel.text = post.location
        let dateSubstring: Substring = post.dateTime!.prefix(10)
        self.dateLabel.text = String(dateSubstring)
        if let fileName = post.image {
            ImageAPI.get(parameters: ["fileName": fileName])
            { response in
                switch response {
                case .success(let image):
                    DispatchQueue.main.async { [self] in
                        postImageView.image = image
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        if post.emailAddress == emailAddress {
            self.favoritesButton.alpha = 0
        } else {
            self.favoritesButton.alpha = 1
        }
        
        self.isFav = isFav
        
        if isFav {
            self.favoritesButton.titleLabel?.text = "Remove From Favorites"
        } else {
            self.favoritesButton.titleLabel?.text = "Add To Favorites"
        }
    }
    
}
