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
    
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: self.postImageView!,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: self.postImageView!,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        self.addConstraints([centerX, centerY])
        return activityIndicator
    }
    
    @IBAction func addRemoveFavorites(_ sender: UIButton) {
        if self.isFav {
            self.favoritesButton.setTitle("Add To Favorites", for: .normal)
            self.delegate.removeFromFavorites(id: post.id)
        } else {
            self.favoritesButton.setTitle("Remove From Favorites", for: .normal)
            self.delegate.addToFavorites(id: post.id)
        }
        self.isFav.toggle()
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
        postImageView.image = nil
        if let fileName = post.image {
            let activityIndicator = self.activityIndicator
            activityIndicator.startAnimating()
            ImageAPI.get(parameters: ["fileName": fileName])
            { response in
                switch response {
                case .success(let image):
                    DispatchQueue.main.async { [self] in
                        postImageView.image = image
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
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
            self.isFav = isFav
            if isFav {
                self.favoritesButton.setTitle("Remove From Favorites", for: .normal)
            } else {
                self.favoritesButton.setTitle("Add To Favorites", for: .normal)
            }
        }

    }
    
}
