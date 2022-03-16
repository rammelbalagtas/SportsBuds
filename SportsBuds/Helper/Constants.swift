//
//  Constants.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-08.
//

import Foundation

struct Constants {
    
    struct Storyboard {
        static let rootTabBarController = "RootTabBarController"
    }
    
    struct Database {
        static let collection = "users"
    }
    
    //reuse identifier for custom nibs
    struct ReuseIdentifier {
        static let myFavTableViewCell = "MyFavPostTableCellIdentifier"
        static let myPostCollectionViewCell = "MyPostCellReuseIdentifier"
    }
    
    //custom nib for table view/collection view cells
    struct NibName {
        static let nibMyPostCollection = "MyPostCollectionViewCell"
        static let nibMyFavTable = "MyFavTableViewCell"
        
    }
}
