//
//  DetailViewController.swift
//  nmpcd
//
//  Created by bally on 12/3/17.
//  Copyright © 2017 bally. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import ImageSlideshow

class DetailViewController: UIViewController {

    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var tradeLabel: UILabel!
    @IBOutlet weak var genericLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var usesLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var precautionLabel: UILabel!
    @IBOutlet weak var storageLabel: UILabel!
    
    let storageRef = Storage.storage().reference()
    var medData: Medicine!
    var imageSource:[ImageSource] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tradeLabel.text = medData.TradeName
        self.genericLabel.text = medData.GenericName
        self.strengthLabel.text = medData.Strength
        self.unitLabel.text = medData.Unit
        self.dosageLabel.text = medData.DosageForm
        self.usesLabel.text = medData.Uses
        self.adminLabel.text = medData.Administration
        self.precautionLabel.text = medData.Precaution
        self.storageLabel.text = medData.Storage
        self.navigationItem.title = medData.TradeName
        
        let reference = storageRef.child("images/" + medData.key + ".jpg")
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
                self.slideShow.isHidden = true
            } else {
                self.imageSource.append(ImageSource(image: UIImage(data: data!)!))
                self.setupSlideShow()
            }
        }
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
    
    func setupSlideShow() {
        slideShow.backgroundColor = UIColor.white
        slideShow.slideshowInterval = 5.0
        slideShow.pageControlPosition = PageControlPosition.underScrollView
        slideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideShow.pageControl.pageIndicatorTintColor = UIColor.black
        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        slideShow.activityIndicator = DefaultActivityIndicator(style: .white, color: UIColor.red)
        slideShow.setImageInputs(imageSource)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.didTap))
        slideShow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! EditViewController
        destination.medData = self.medData
    }
}
