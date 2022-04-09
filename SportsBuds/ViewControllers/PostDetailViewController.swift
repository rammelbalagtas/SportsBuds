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

    @IBOutlet weak var addChangePhotoBtn: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var sportTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var postDateTime: UIDatePicker!
    
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func addChangePhotoAction(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
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
        var imageGUID: String? = nil
        
        if let post = self.post {
            id = post.id
        } else {
            id = 0
        }
        
        //store image to blob storage
        if let image = postImageView.image {
            
            guard
                let imageData = image.jpegData(compressionQuality: 1.0)
            else{return}
            
            imageGUID = "Posts/Pictures/\(UUID().uuidString).jpg"
            ImageAPI.create(imageData: imageData, parameters: ["imageName": imageGUID! ])
            { response in
                switch response {
                case .success(_):
                    print("successfully uploaded photo")
                case .failure(let error):
                    imageGUID = nil
                    print(error)
                }
            }
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
                        image: imageGUID)
        if id == 0 {
            PostAPI.create(post: post)
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
        } else {
            PostAPI.update(post: post)
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
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        PostAPI.delete(post: post!)
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
            
            if let fileName = post.image {
                self.postImageView.startAnimating()
                ImageAPI.get(parameters: ["fileName": fileName])
                { response in
                    switch response {
                    case .success(let image):
                        DispatchQueue.main.async {
                            self.postImageView.image = image
                            self.postImageView.stopAnimating()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }

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
                addChangePhotoBtn.isEnabled = false
            }
        } else {
            editButton.isEnabled = false
            deleteButton.isEnabled = false
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

}

extension PostDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        self.postImageView.image = image
        
//        if let image = postImageView.image {
//            guard
//                let imageData = image.jpegData(compressionQuality: 1.0)
//            else{return}
//
//            ImageAPI.create(imageData: imageData, parameters: ["imageName": "Posts/Pictures/1/\(UUID().uuidString).jpg"])
//            { response in
//                switch response {
//                case .success(_):
//                    DispatchQueue.main.async {
//
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }
        
    }
    
}
