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
    var emailAddress: String?
    var longitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    
    @IBOutlet weak var buttonStackView: UIStackView!
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
        addLocationButton.isEnabled = true
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        var id = 0
        var httpMethod = ""
        
        if let post = self.post {
            id = post.id
            httpMethod = "PUT"
        } else {
            id = 0
            httpMethod = "POST"
        }
        
        let post = Post(id: id,
                        title: titleTextField.text!,
                        sport: sportTextField.text!,
                        description: descriptionTextView.text,
                        location: locationText.text!,
                        latitude: latitude!,
                        longitude: longitude!,
                        dateTime: nil,
                        emailAddress: emailAddress!,
                        image: nil)
        
        APIHelper.postData(post: post, httpMethod: httpMethod)
        { response in
            switch response {
            case .success( _):
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindToHome", sender: self)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func deleteAction(_ sender: UIButton) {
        APIHelper.postData(post: post!, httpMethod: "DELETE")
        { response in
            switch response {
            case .success( _):
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindToHome", sender: self)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //disable editing by default for existing post
        if let post = post {
            //bind values
            titleTextField.text = post.title
            sportTextField.text = post.sport
            descriptionTextView.text = post.description
            locationText.text = post.location
            latitude = post.latitude
            longitude = post.longitude
            
            //set editability of fields
            titleTextField.isUserInteractionEnabled = false
            sportTextField.isUserInteractionEnabled = false
            descriptionTextView.isUserInteractionEnabled = false
            postDateTime.isUserInteractionEnabled = false
            addLocationButton.isUserInteractionEnabled = false
            if post.emailAddress != emailAddress {
                buttonStackView.alpha = 0
            }
        }
        
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
