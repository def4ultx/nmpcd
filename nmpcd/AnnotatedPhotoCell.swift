//
//  AnnotatedPhotoCell.swift
//  nmpcd
//
//  Created by Sirawit Honghom on 12/4/2560 BE.
//  Copyright © 2560 bally. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var drugNameLabel: UILabel!
    @IBOutlet fileprivate weak var drugDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    
//    var photo: Photo? {
//        didSet {
//            if let photo = photo {
//                imageView.image = photo.image
//                captionLabel.text = photo.caption
//                commentLabel.text = photo.comment
//            }
//        }
//    }
}
