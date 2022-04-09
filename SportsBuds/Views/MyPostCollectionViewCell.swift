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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(using post: Post) {
        self.titleLabel.text = post.title
        if let fileName = post.image {
            ImageAPI.get(parameters: ["fileName": fileName])
            { response in
                switch response {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.myPostImage.image = image
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

}


