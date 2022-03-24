//
//  PostDetailViewController.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-18.
//

import UIKit
import MapKit

class PostDetailViewController: UIViewController {
    
    var post: Post?
    var longitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var sportTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var postDateTime: UIDatePicker!
    
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBAction func editAction(_ sender: UIButton) {
        titleTextField.isUserInteractionEnabled = true
        sportTextField.isUserInteractionEnabled = true
        descriptionTextView.isUserInteractionEnabled = true
        postDateTime.isUserInteractionEnabled = true
        addLocationButton.isUserInteractionEnabled = true
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
//        postDateTime.datePickerMode = .time
//        let date = postDateTime.date
//        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
//        let hour = components.hour!
//        let minute = components.minute!
        
        let post = Post(id: 5,
                        title: titleTextField.text!,
//                        sport: sportTextField.text!,
                        description: descriptionTextView.text,
                        location: locationText.text!,
                        latitude: latitude!,
                        longitude: longitude!,
                        date: nil)
//                        date: postDateTime.date)
        APIHelper.postData(post: post, httpMethod: "DELETE") { response in
            switch response {
            case .success(let post):
                print("success")
            case .failure(let error):
                print("success")
            }
        }
        //call API to post
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addLocationButton.isEnabled = false	
        
        //disable editing by default for existing post
//        if let post = post {
//            if post.id != 0 {
//                titleTextField.isUserInteractionEnabled = false
//                sportTextField.isUserInteractionEnabled = false
//                descriptionTextView.isUserInteractionEnabled = false
//                postDateTime.isUserInteractionEnabled = false
//                addLocationButton.isUserInteractionEnabled = false
//            }
//        } else {
////            editButton.alpha = 0
//        }
        
        //add border to textview
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = borderColor.cgColor
        descriptionTextView.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToPostDetail( _ seg: UIStoryboardSegue) {
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
