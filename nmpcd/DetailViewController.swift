//
//  DetailViewController.swift
//  nmpcd
//
//  Created by bally on 12/3/17.
//  Copyright © 2017 bally. All rights reserved.
//

import UIKit
import ImageSlideshow

class DetailViewController: UIViewController {

    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var tradeLabel: UILabel!
    @IBOutlet weak var genericLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var usesLabel: UITextView!
    @IBOutlet weak var adminTextView: UITextView!
    @IBOutlet weak var precautionTextView: UITextView!
    @IBOutlet weak var storageLabel: UILabel!
    var medData: Medicine!
    
    let localSource = [ImageSource(imageString: "nmpcd")!, ImageSource(imageString: "nmpcd")!]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupSlideShow()
        self.tradeLabel.text = medData.TradeName
        self.genericLabel.text = medData.GenericName
        self.strengthLabel.text = medData.Strength
        self.unitLabel.text = medData.Unit
        self.dosageLabel.text = medData.DosageForm
        self.usesLabel.text = medData.Uses
        self.adminTextView.text = medData.Administration
        self.precautionTextView.text = medData.Precaution
        self.storageLabel.text = medData.Storage
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
//        slideShow.currentPageChanged = { page in
//            print("current page:", page)
//        }
        slideShow.setImageInputs(localSource)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.didTap))
        slideShow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}
