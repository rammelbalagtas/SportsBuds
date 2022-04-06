//
//  SearchPostViewController.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-08.
//

import UIKit

class SearchPostViewController: UIViewController {

    @IBOutlet weak var viewSegmentedControl: UISegmentedControl!
    
    @IBAction func onChangeSelection(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private lazy var mapResultViewController: MapResultViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "MapResultViewController") as! MapResultViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()

    private lazy var listResultViewController: ListResultViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "ListResultViewController") as! ListResultViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func updateView() {
        if viewSegmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: listResultViewController)
            add(asChildViewController: mapResultViewController)
        } else {
            remove(asChildViewController: mapResultViewController)
            add(asChildViewController: listResultViewController)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSegmentedControl.selectedSegmentIndex = 0
        add(asChildViewController: mapResultViewController)
        // Do any additional setup after loading the view.
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
