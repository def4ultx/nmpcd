//
//  EditViewController.swift
//  nmpcd
//
//  Created by Sirawit Honghom on 12/6/2560 BE.
//  Copyright © 2560 bally. All rights reserved.
//

import UIKit
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
    private let barcodeController = BarcodeScannerController()
    
    
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
        
//        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
//            if user != nil {
//                self.performSegue(withIdentifier: self.loginToList, sender: nil)
//            }
//        }

        self.addPhotoButton.titleLabel?.textAlignment = .center
        self.addPhotoButton.setTitle("add \n photo", for: UIControlState.normal)
        addImage.isHidden = true
        self.hideKeyboardWhenTappedAround()
        self.barcodeController.codeDelegate = self
        self.barcodeController.errorDelegate = self
        self.barcodeController.dismissalDelegate = self
        
        
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
