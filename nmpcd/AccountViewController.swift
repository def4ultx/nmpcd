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

class AccountViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var databaseRef: DatabaseReference!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBAction func addPhotoMethod(_ sender: Any) {
        chooseImage()
    }
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.roundConner(item: self.logoutButton, radius: 8)
        
        // Do any additional setup after loading the view.
        self.databaseRef = Database.database().reference()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.databaseRef.child("user-list")
                    .queryOrdered(byChild: "email")
                    .queryEqual(toValue: user?.email!)
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.exists() {
                            let childData = (snapshot.value as! NSDictionary).allValues[0] as! NSDictionary
                            self.fullnameLabel.text = childData.value(forKey: "fullname") as? String
                            self.emailLabel.text = childData.value(forKey: "email") as? String
                            self.genderLabel.text = childData.value(forKey: "gender") as? String
                            self.birthdayLabel.text = childData.value(forKey: "birthday") as? String
                            self.ageLabel.text = childData.value(forKey: "age") as? String
                        }
                })
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
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func chooseImage(){
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (action:UIAlertAction) in imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            (action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addPhotoButton.setImage(image, for: UIControlState.normal)
            
            
        }else {
            //Error message
        }
        self.dismiss(animated: true, completion: nil)
        print("camera is dismissed or not")
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
