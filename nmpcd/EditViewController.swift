//
//  EditViewController.swift
//  nmpcd
//
//  Created by Sirawit Honghom on 12/6/2560 BE.
//  Copyright © 2560 bally. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var cancelButton: UINavigationItem!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var genericField: UITextField!
    @IBOutlet weak var strengeField: UITextField!
    @IBOutlet weak var dosageField: UITextField!
    @IBOutlet weak var usesView: UILabel!
    @IBOutlet weak var adminField: UITextField!
    @IBOutlet weak var precautionView: UITextView!
    @IBOutlet weak var storageField: UITextField!
    @IBOutlet weak var barcodeField: UITextField!
    
    var editTradeName = ""
    var editStrength = ""
    var editUses = ""
    var editUnit = ""
    var editStorage = ""
    var editDosageForm = ""
    var editPrecaution = ""
    var editAdministration = ""
    var editBarcodeNo = ""
    var editGenericName = ""
    
    
    @IBAction func cancelMethod(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        chooseImage()
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
            addImage.image = image
            addImage.isHidden = false
            addPhotoButton.isHidden = true
            
        }else {
            //Error message
        }
        self.dismiss(animated: true, completion: nil)
        print("camera is dismissed or not")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addPhotoButton.titleLabel?.textAlignment = .center
        self.addPhotoButton.setTitle("add \n photo", for: UIControlState.normal)
        addImage.isHidden = true
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
