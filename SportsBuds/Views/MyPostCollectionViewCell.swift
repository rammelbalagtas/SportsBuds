//
//  MyPostCollectionViewCell.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-09.
//

import UIKit

class MyPostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myPostImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: self.myPostImage!,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: self.myPostImage!,
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
    
    func configureCell(using post: Post) {
        self.titleLabel.text = post.title
        self.myPostImage.image = nil
        if let fileName = post.image {
            let activityIndicator = self.activityIndicator
            activityIndicator.startAnimating()
            ImageAPI.get(parameters: ["fileName": fileName])
            { response in
                switch response {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.myPostImage.image = image
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


