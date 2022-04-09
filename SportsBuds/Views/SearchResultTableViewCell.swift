//
//  SeaerchResultTableViewCell.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-30.
//

import UIKit

protocol SearchResultTableCell {
    func addToFavorites()
}

class SearchResultTableViewCell: UITableViewCell {
    
    var delegate: SearchResultTableCell!
    var post: Post!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        FavoritesAPI.create(parameters: ["emailAddress":"test3@gmail.com", "postId": String(post.id)])
        { response in
            switch response {
            case .success(_):
                DispatchQueue.main.async { [self] in
                    self.favoritesButton.titleLabel?.text = "Remove From Favorites"
                }
            case .failure(let error):
                print(error)
            }
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
    
    func configureCell(using post: Post, emailAddress: String) {
        self.post = post
        self.postTitleLabel.text = post.title
        self.locationLabel.text = post.location
        self.dateLabel.text = post.dateTime
        if let fileName = post.image {
            ImageAPI.get(parameters: ["fileName": fileName])
            { response in
                switch response {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.postImageView.image = image
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
    }
    
}
