//
//  AccountViewController.swift
//  nmpcd
//
//  Created by bally on 12/4/17.
//  Copyright © 2017 bally. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AccountViewController: UIViewController {

    var databaseRef: DatabaseReference!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.roundConner(item: self.logoutButton, radius: 8)
        // Do any additional setup after loading the view.
        self.databaseRef = Database.database().reference()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print(user?.email!)
            } else {
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutAction(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let alert = UIAlertController(title: "Success", message: "Logout successful.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
