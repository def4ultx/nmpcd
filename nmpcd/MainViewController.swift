//
//  MainViewController.swift
//  nmpcd
//
//  Created by bally on 12/3/17.
//  Copyright © 2017 bally. All rights reserved.
//

import UIKit
import BarcodeScanner

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var recentSearch = ["Paracetamol","Vitamin C","Vitamin E"]
    private let barcodeController = BarcodeScannerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        self.tableView.tableFooterView = UIView()
        self.barcodeController.codeDelegate = self
        self.barcodeController.errorDelegate = self
        self.barcodeController.dismissalDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if searchBar.text != nil {
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

extension MainViewController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            controller.resetWithError()
        }
    }
}

extension MainViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension MainViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
