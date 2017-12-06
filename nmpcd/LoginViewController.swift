//
//  LoginViewController.swift
//  nmpcd
//
//  Created by bally on 12/4/17.
//  Copyright © 2017 bally. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    var handle: AuthStateDidChangeListenerHandle!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if self.emailText.text == "" || self.passwordText.text == "" {
            self.pushAlert(title: "Error", message: "Please enter an email and password.", action: "OK", style: .cancel)
        } else {
            Auth.auth().signIn(withEmail: self.emailText.text!, password: self.passwordText.text!) { (user, error) in
                if error == nil {
                    self.pushAlert(title: "Success", message: "Login successful.", action: "OK", style: .cancel)
                } else {
                    self.pushAlert(title: "Error", message: (error?.localizedDescription)!, action: "OK", style: .cancel)
                }
            }
        }
    }
    
    @IBAction func forgotAction(_ sender: Any) {
        let alert = UIAlertController(title: "Password Reset", message: "Please enter your email.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
            textField.keyboardType = UIKeyboardType.emailAddress
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            Auth.auth().sendPasswordReset(withEmail: (alert?.textFields![0].text)!, completion: { (error) in
                var title: String
                var message: String
                if error != nil {
                    title = "Error"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success"
                    message = "Password reset email sent."
                }
                self.pushAlert(title: title, message: message, action: "OK", style: .cancel)
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func pushAlert(title: String, message: String, action: String, style: UIAlertActionStyle) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: action, style: style, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
