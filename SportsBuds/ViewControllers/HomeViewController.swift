//
//  HomeViewController.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-08.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate {
    
    var emailAddress: String?
    var myPostList = [Post]()
    var myFavList = [Post]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    //Register nib for collection view and table view cells
    func registerNib() {
        
        //Register nib for collection view
        let nibCollection = UINib(nibName: Constants.NibName.nibMyPostCollection, bundle: nil)
        collectionView?.register(nibCollection, forCellWithReuseIdentifier: Constants.ReuseIdentifier.myPostCollectionViewCell)
        
        //Register nib for table view
        let nibTable = UINib(nibName: Constants.NibName.nibMyFavTable, bundle: nil)
        tableView.register(nibTable, forCellReuseIdentifier: Constants.ReuseIdentifier.myFavTableViewCell)
    }
    
    func loadData() {
        
        PostAPI.get(url: PostAPI.postURL, parameters: ["emailAddress": emailAddress!])
        { [self] response in
            switch response {
            case .success(let data):
                myPostList = data
                DispatchQueue.main.async { [self] in
                    collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        FavoritesAPI.get(url: FavoritesAPI.favoritesURL, parameters: ["emailAddress": emailAddress!])
        { [self] response in
            switch response {
            case .success(let data):
                myFavList = data
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func unwindToHome( _ seg: UIStoryboardSegue) {
        loadData()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PostDetailViewController {
            destination.emailAddress = emailAddress
            if segue.identifier == "ViewMyPost" {
                if let indexPaths = collectionView.indexPathsForSelectedItems {
                    destination.post = myPostList[indexPaths[0].row]
                }
            } else if segue.identifier == "ViewFavorite" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    destination.post = myFavList[indexPath.row]
                }
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UITableViewDataSource {
    
    //collection view cells count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPostList.count
    }
    
    //data per collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuseIdentifier.myPostCollectionViewCell, for: indexPath) as? MyPostCollectionViewCell
        else{preconditionFailure("unable to dequeue reusable cell")}
        let post = myPostList[indexPath.row]
        cell.configureCell(using: post)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewMyPost", sender: self)
    }
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFavList.count
    }
    
    // data per table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifier.myFavTableViewCell, for: indexPath) as? MyFavTableViewCell
        else{preconditionFailure("unable to dequeue reusable cell")}
        let post = myFavList[indexPath.row]
        cell.configureCell(using: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewFavorite", sender: self)
    }
    
}
