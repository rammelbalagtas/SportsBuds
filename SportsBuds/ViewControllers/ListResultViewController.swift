//
//  ListResultViewController.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-30.
//

import UIKit

class ListResultViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        
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
//            destination.emailAddress = emailAddress
//            if segue.identifier == "ViewMyPost" {
//                if let indexPaths = collectionView.indexPathsForSelectedItems {
//                    destination.post = myFavList[indexPaths[0].row]
//                }
//            } else if segue.identifier == "ViewFavorite" {
//                if let indexPath = tableView.indexPathForSelectedRow {
//                    destination.post = myFavList[indexPath.row]
//                }
//            }
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
        return 3
    }
    
    // data per table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifier.searchResultViewCell, for: indexPath) as? SearchResultTableViewCell
        else{preconditionFailure("unable to dequeue reusable cell")}
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "ViewFavorite", sender: self)
    }
    
}
