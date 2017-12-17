//
//  EditViewController.swift
//  nmpcd
//
//  Created by Sirawit Honghom on 12/6/2560 BE.
//  Copyright © 2560 bally. All rights reserved.
//

import UIKit
import BarcodeScanner
import BSImagePicker
import Photos

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate{

    @IBOutlet weak var barcodeButton: UIButton!
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
        let allAssets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        var evenAssetIds = [String]()
        
        allAssets.enumerateObjects({ (asset, idx, stop) -> Void in
            if idx % 2 == 0 {
                evenAssetIds.append(asset.localIdentifier)
            }
        })
        
        let evenAssets = PHAsset.fetchAssets(withLocalIdentifiers: evenAssetIds, options: nil)
        
        let vc = BSImagePickerViewController()
        vc.defaultSelections = evenAssets

        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (action:UIAlertAction) in imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))

        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            (action:UIAlertAction) in self.bs_presentImagePickerController(vc, animated: true,
                                            select: { (asset: PHAsset) -> Void in
                                                print("Selected: \(asset)")
            }, deselect: { (asset: PHAsset) -> Void in
                print("Deselected: \(asset)")
            }, cancel: { (assets: [PHAsset]) -> Void in
                print("Cancel: \(assets)")
            }, finish: { (assets: [PHAsset]) -> Void in
                print("Finish: \(assets)")
            }, completion: nil)
        }))
       

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImage.image = image
            addImage.isHidden = false
            addPhotoButton.isHidden = false
            
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
