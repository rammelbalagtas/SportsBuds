//
//  LoginViewController.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-08.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailAddressText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        //validate Text Fields
        let email = emailAddressText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email == "" || password == "" {
            self.errorLabel.text = "Please fill in all fields"
            self.errorLabel.alpha = 1
            return
        }
        
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password)
        { (result, error) in
            if let error = error {
                self.errorLabel.text = error.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                self.transitionToHome()
            }
        }
    }
    
    //set HomeViewController as root controller after successful signup
    func transitionToHome() {
        let homeNavVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeNavVC) as? UINavigationController
        view.window?.rootViewController = homeNavVC
        view.window?.makeKeyAndVisible()
    }

}
