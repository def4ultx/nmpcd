//
//  RoundTextView.swift
//  nmpcd
//
//  Created by FondFondd on 18/12/2560 BE.
//  Copyright © 2560 bally. All rights reserved.
//

import UIKit

@IBDesignable
class RoundTextView: UITextView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var boederWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = boederWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }

}
