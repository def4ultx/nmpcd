//
//  EditViewController.swift
//  nmpcd
//
//  Created by Sirawit Honghom on 12/6/2560 BE.
//  Copyright © 2560 bally. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import BarcodeScanner

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate{

    @IBOutlet weak var barcodeButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var cancelButton: UINavigationItem!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var genericField: UITextField!
    @IBOutlet weak var strengeField: UITextField!
    @IBOutlet weak var unitField: UITextField!
    @IBOutlet weak var dosageField: UITextField!
    @IBOutlet weak var usesTextView: UITextView!
    @IBOutlet weak var adminTextView: UITextView!
    @IBOutlet weak var precautionView: UITextView!
    @IBOutlet weak var storageTextView: UITextView!
    @IBOutlet weak var barcodeField: UITextField!
    
    private let barcodeController = BarcodeScannerController()
    
    
    var databaseRef: DatabaseReference!
    let storageRef = Storage.storage().reference()
    var medData: Medicine?
    
    @IBAction func cancelMethod(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        chooseImage()
    }
    
    @IBAction func barcodeMethod(_ sender: Any) {
        barcodeController.title = "Barcode Scanner"
        present(barcodeController, animated: true, completion: nil)
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

        self.databaseRef = Database.database().reference()
        self.addPhotoButton.titleLabel?.textAlignment = .center
        self.addPhotoButton.setTitle("add \n photo", for: UIControlState.normal)
        addImage.isHidden = true
        self.hideKeyboardWhenTappedAround()
        self.barcodeController.codeDelegate = self
        self.barcodeController.errorDelegate = self
        self.barcodeController.dismissalDelegate = self
        
        
        // Do any additional setup after loading the view.
        
        if ((self.medData) != nil) {
            self.navigationItem.title = "Edit"
            nameField.text = medData?.TradeName
            genericField.text = medData?.GenericName
            strengeField.text = medData?.Strength
            unitField.text = medData?.Unit
            dosageField.text = medData?.DosageForm
            usesTextView.text = medData?.Uses
            adminTextView.text = medData?.Administration
            precautionView.text = medData?.Precaution
            storageTextView.text = medData?.Storage
            barcodeField.text = medData?.BarcodeNo
        } else {
            self.navigationItem.title = "Add"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func uploadData(_ sender: Any) {
        var key: String
        if (medData?.key != nil) {
            key = (medData?.key)!
        } else {
            key = databaseRef.child("medicine-list").childByAutoId().key
        }
        let post = ["Administration": adminTextView.text!,
                "BarcodeNo": barcodeField.text!,
                "DosageForm": dosageField.text!,
                "GenericName": genericField.text!,
                "LowerGenericName": (genericField.text)?.lowercased(),
                "Precaution": precautionView.text!,
                "Strength": strengeField.text!,
                "Storage": storageTextView.text!,
                "TradeName": nameField.text!,
                "LowerTradeName": (nameField.text)?.lowercased(),
                "Unit": unitField.text!,
                "Uses": usesTextView.text!,
                "key": key]
        let childUpdates = ["/medicine-list/\(key)": post]
        databaseRef.updateChildValues(childUpdates)
        let imageRef = storageRef.child("images/" + key + ".jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        var data = Data()
        data = UIImageJPEGRepresentation(addImage.image!, 0.8)!
        imageRef.putData(data, metadata: metadata)
    }
}

extension EditViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension EditViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension EditViewController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        self.barcodeField.text = String(code)
        controller.dismiss(animated: true, completion: nil)
        
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            controller.resetWithError()
        }
    }
}
