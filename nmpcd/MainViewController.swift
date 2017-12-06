//
//  MainViewController.swift
//  nmpcd
//
//  Created by bally on 12/3/17.
//  Copyright © 2017 bally. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import BarcodeScanner

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var recentSearch = ["Paracetamol","Vitamin C","Vitamin E"]
    private let barcodeController = BarcodeScannerController()
    var medData: Medicine!
    var databaseRef: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.databaseRef = Database.database().reference()
        self.hideKeyboardWhenTappedAround()
        self.tableView.tableFooterView = UIView()
        self.barcodeController.codeDelegate = self
        self.barcodeController.errorDelegate = self
        self.barcodeController.dismissalDelegate = self
        
//        let hambergerButton = UIButton(type: .system)
//        hambergerButton.setImage(#imageLiteral(resourceName: "hamberger"), for: .normal)
//        hambergerButton.addTarget(self, action: #selector(MainViewController.fbButtonPressed), for: UIControlEvents.touchUpInside)
//        hambergerButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: hambergerButton)
    }
    
    @objc func fbButtonPressed() {
        
        print("Share to fb")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    @IBAction func clearRecentMethod(_ sender: Any) {
        self.recentSearch.removeAll()
        self.tableView.reloadData()
    }
    
    @IBAction func scanBarcodeMethod(_ sender: Any) {
        barcodeController.title = "Barcode Scanner"
        present(barcodeController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath)
        tableCell.textLabel?.text = recentSearch[indexPath.row]
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "searchSegue", sender: self.tableView)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            tableView.beginUpdates()
            recentSearch.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let _ = searchBar.text {
            performSegue(withIdentifier: "searchSegue", sender: searchBar)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchSegue" {
            var searchText: String!
            if type(of: sender!) == UISearchBar.self {
                searchText = self.searchBar.text
            } else if type(of: sender!) == UITableView.self {
                let indexPath = self.tableView.indexPathForSelectedRow
                searchText = recentSearch[indexPath!.row]
            }
            let destination = segue.destination as! SearchViewController
            destination.searchText = searchText
        } else if segue.identifier == "detailSegue" {
            let destination = segue.destination as! DetailViewController
            destination.medData = self.medData
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MainViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        self.databaseRef.child("medicine-list")
            .queryOrdered(byChild: "BarcodeNo")
            .queryEqual(toValue: code)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let childData = (snapshot.value as! NSDictionary).allValues[0] as! NSDictionary
                    self.medData = AppUtility.queryData(childData: childData)
                    self.barcodeController.reset(animated: true)
                    self.barcodeController.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "detailSegue", sender: self.databaseRef)
                } else {
                    self.barcodeController.resetWithError()
                }
        })
    }
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    static func queryData(childData: NSDictionary) -> Medicine {
        let administration = childData.value(forKey: "Administration") as! String
        let barcode = childData.value(forKey: "BarcodeNo") as! String
        let dosage = childData.value(forKey: "DosageForm") as! String
        let generic = childData.value(forKey: "GenericName") as! String
        let precaution = childData.value(forKey: "Precaution") as! String
        let strength = childData.value(forKey: "Strength") as! String
        let storage = childData.value(forKey: "Storage") as! String
        let tradename = childData.value(forKey: "TradeName") as! String
        let unit = childData.value(forKey: "Unit") as! String
        let uses = childData.value(forKey: "Uses") as! String
        let key = childData.value(forKey: "key") as! String
        let medData = Medicine(admin: administration, barcode: barcode, dosage: dosage, generic: generic, precaution: precaution, storage: storage, strength: strength, trade: tradename, unit: unit, uses: uses, key: key)
        return medData!
    }
}
