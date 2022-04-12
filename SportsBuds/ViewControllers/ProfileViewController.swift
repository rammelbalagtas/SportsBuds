//
//  ProfileViewController.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-08.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var emailAddress: String?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBAction func changePhotoAction(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = emailAddress
    }

}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        self.profileImage.image = image
        
    }
    
}
