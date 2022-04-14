//
//  MyFavTableViewCell.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-09.
//

import UIKit

class MyFavTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var myFavImage: UIImageView!
    
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: self.myFavImage!,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: self.myFavImage!,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        self.addConstraints([centerX, centerY])
        return activityIndicator
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(using post: Post) {
        self.nameLabel.text = post.title
        self.locationLabel.text = post.location
        let dateSubstring: Substring = post.dateTime!.prefix(10)
        self.dateLabel.text = String(dateSubstring)
        self.myFavImage.image = nil
        if let fileName = post.image {
            let activityIndicator = self.activityIndicator
            activityIndicator.startAnimating()
            ImageAPI.get(parameters: ["fileName": fileName])
            { response in
                switch response {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.myFavImage.image = image
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
