//
//  SignUpViewController.swift
//  nmpcd
//
//  Created by bally on 12/6/17.
//  Copyright © 2017 bally. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var bdayField: UITextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    var databaseRef: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        if emailField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else if passwordField.text != confirmPasswordField.text {
            let alertController = UIAlertController(title: "Error", message: "Password are not match!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if error == nil {
                    let key = self.databaseRef.child("user-list").childByAutoId().key
                    let post = ["fullname": self.firstNameField.text! + " " + self.lastNameField.text!,
                                "age": "24",
                                "email": self.emailField.text!,
                                "gender": self.genderField.text!,
                                "birhtday": self.bdayField.text!]
                    let childUpdates = ["/user-list/\(key)": post]
                    self.databaseRef.updateChildValues(childUpdates)
                    let alertController = UIAlertController(title: "Success", message: "Create account successful!", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action: UIAlertAction!) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
