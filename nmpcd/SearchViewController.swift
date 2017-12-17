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

class SearchViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var searchText: String!
    var databaseRef: DatabaseReference!
    let storageRef = Storage.storage().reference()
    private var medData = [Medicine]()
    private var medDetail: Medicine!
    private let barcodeController = BarcodeScannerController()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let itemSize = UIScreen.main.bounds.width/2 - 3
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
//        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
        
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
        if let text = searchBar.text {
            self.searchText = text
            self.loadSearchData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath) as! AnnotatedPhotoCell
        cell.medNameLabel.text = medData[indexPath.row].TradeName
        cell.medCaptionLabel.text = medData[indexPath.row].GenericName + " " + medData[indexPath.row].Strength + medData[indexPath.row].Unit
        let reference = storageRef.child("images/" + medData[indexPath.row].key + ".jpg")
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                cell.imageView.image = UIImage(data: data!)
                cell.imageView.contentMode = .scaleAspectFit
            }
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
//        return CGSize(width: itemSize, height: itemSize)
//    }
    
    func loadSearchData() {
        self.medData = [Medicine]()
        self.navigationItem.title = searchText
        self.searchBar.text = searchText
        self.searchText = searchText.lowercased()
        self.databaseRef.child("medicine-list")
            .queryOrdered(byChild: "LowerGenericName")
            .queryStarting(atValue: searchText)
            .queryEnding(atValue: searchText + "{\\uf8ff}")
            .observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let childData = (child as! DataSnapshot).value as! NSDictionary
                    let med = AppUtility.queryData(childData: childData)
                    self.medData.append(med)
                }
                self.databaseRef.child("medicine-list")
                    .queryOrdered(byChild: "LowerTradeName")
                    .queryStarting(atValue: self.searchText)
                    .queryEnding(atValue: self.searchText + "{\\uf8ff}")
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                        for child in snapshot.children {
                            let childData = (child as! DataSnapshot).value as! NSDictionary
                            let med = AppUtility.queryData(childData: childData)
                            if (!self.medData.contains(where: { $0.key == med.key})) {
                                self.medData.append(med)
                            }
                        }
                        self.collectionView.reloadData()
                })
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            var med: Medicine!
            if type(of: sender!) == DatabaseReference.self {
                med = self.medDetail!
            } else if type(of: sender!) == AnnotatedPhotoCell.self {
                let cell = sender as? UICollectionViewCell
                let indexPath = self.collectionView.indexPath(for: cell!)
                med = medData[(indexPath?.row)!]
            }
            let destination = segue.destination as! DetailViewController
            destination.medData = med!
        }
    }
}

extension SearchViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        self.databaseRef.child("medicine-list")
            .queryOrdered(byChild: "BarcodeNo")
            .queryEqual(toValue: code)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let childData = (snapshot.value as! NSDictionary).allValues[0] as! NSDictionary
                    self.medDetail = AppUtility.queryData(childData: childData)
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
