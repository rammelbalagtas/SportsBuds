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
        self.dateLabel.text = post.dateTime
        if let fileName = post.image {
            ImageAPI.get(parameters: ["fileName": fileName])
            { response in
                switch response {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.myFavImage.image = image
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
