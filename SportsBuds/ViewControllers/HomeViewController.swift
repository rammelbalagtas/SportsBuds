//
//  HomeViewController.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-08.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate {
    
    var myPostList = [PostApi]()
    var myFavList = [PostApi]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        APIHelper.fetchPost(url: "\(APIHelper.baseURL)/api/posts")
        { [self] response in
            switch response {
            case .success(let data):
                myPostList = data
                myFavList = data
                DispatchQueue.main.async {
                    tableView.reloadData()
                    collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
}
