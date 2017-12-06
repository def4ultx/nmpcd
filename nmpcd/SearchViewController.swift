//
//  SearchViewController.swift
//  nmpcd
//
//  Created by bally on 12/3/17.
//  Copyright © 2017 bally. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import BarcodeScanner

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    var photos = ["1","2","3","4","5"]
    //["tylenol-8hour","tylenol-500ml-100pcs","tylenol-500ml-200pcs","tylenol-childrens","tylenol-infants-5ml"]
    
    var searchText: String!
    var databaseRef: DatabaseReference!
    private var medData = [Medicine]()
    private let barcodeController = BarcodeScannerController()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.databaseRef = Database.database().reference()
        self.hideKeyboardWhenTappedAround()
        self.barcodeController.codeDelegate = self
        self.barcodeController.errorDelegate = self
        self.barcodeController.dismissalDelegate = self
        
        //collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        self.loadSearchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    
    @IBAction func scanBarcodeMethod(_ sender: Any) {
        barcodeController.title = "Barcode Scanner"
        present(barcodeController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil && searchBar.text != "" {
            self.searchText = searchBar.text
            self.loadSearchData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath) as! AnnotatedPhotoCell
        cell.imageView.image = UIImage(named: photos[0])
        cell.medNameLabel.text = medData[indexPath.row].TradeName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    private func loadSearchData() {
        self.navigationItem.title = searchText
        searchText = searchText.lowercased()
        self.databaseRef.child("medicine-list")
            .queryOrdered(byChild: "GenericName")
            .queryStarting(atValue: searchText)
            .queryEnding(atValue: searchText + "{\\uf8ff}")
            .observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let childData = (child as! DataSnapshot).value as! NSDictionary
                    let med = AppUtility.queryData(childData: childData)
                    self.medData.append(med)
                }
                self.collectionView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
        }
    }
}


extension SearchViewController: BarcodeScannerCodeDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            controller.resetWithError()
        }
    }
}

extension SearchViewController: BarcodeScannerErrorDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension SearchViewController: BarcodeScannerDismissalDelegate {
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


