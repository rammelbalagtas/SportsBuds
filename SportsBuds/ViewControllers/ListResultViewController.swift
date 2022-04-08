//
//  ListResultViewController.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-30.
//

import UIKit

class ListResultViewController: UIViewController, UITableViewDelegate {
    
    var postList = [Post]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        PostAPI.get(url: PostAPI.postURL, parameters: ["latitude":"13", "longitude": "12"])
        { [self] response in
            switch response {
            case .success(let data):
                postList = data
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    //Register nib for collection view and table view cells
    func registerNib() {
        
        //Register nib for table view
        let nibTable = UINib(nibName: Constants.NibName.nibSearchResultTable, bundle: nil)
        tableView.register(nibTable, forCellReuseIdentifier: Constants.ReuseIdentifier.searchResultViewCell)
    }
    

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PostDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.post = postList[indexPath.row]
            }
        }
    }

}

extension ListResultViewController: UITableViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewMyPost", sender: self)
    }
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    // data per table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifier.searchResultViewCell, for: indexPath) as? SearchResultTableViewCell
        else{preconditionFailure("unable to dequeue reusable cell")}
        let post = postList[indexPath.row]
        cell.configureCell(using: post)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPostSegue", sender: self)
    }
    
}

extension ListResultViewController: SearchResultTableCell {
    func addToFavorites() {
        
    }
}
