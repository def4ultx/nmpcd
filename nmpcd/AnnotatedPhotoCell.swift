//
//  AnnotatedPhotoCell.swift
//  nmpcd
//
//  Created by FondFondd on 5/12/2560 BE.
//  Copyright © 2560 bally. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var medNameLabel: UILabel!
    @IBOutlet weak var medCaptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.borderWidth = 3
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.masksToBounds = true
    }
    
}
