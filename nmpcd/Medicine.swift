//
//  Medicine.swift
//  nmpcd
//
//  Created by bally on 12/5/17.
//  Copyright © 2017 bally. All rights reserved.
//

import Foundation
class Medicine {
    var Administration: String!
    var BarcodeNo: String!
    var DosageForm: String!
    var GenericName: String!
    var Precaution: String!
    var Storage: String!
    var Strength: String!
    var TradeName: String!
    var Unit: String!
    var Uses: String!
    init?(admin: String?, barcode: String?, dosage: String?, generic: String?, precaution: String?, storage: String?, strength: String?, trade: String?, unit: String?, uses: String?) {
//        if (barcode!.isEmpty || usage!.isEmpty || name!.isEmpty) {
//            return nil
//        }
        self.Administration = admin         != nil ? admin  : nil
        self.BarcodeNo      = barcode       != nil ? barcode: nil
        self.DosageForm     = dosage        != nil ? dosage : nil
        self.GenericName    = generic       != nil ? generic    : nil
        self.Precaution     = precaution    != nil ? precaution : nil
        self.Storage        = storage       != nil ? storage    : nil
        self.Strength       = strength      != nil ? strength   : nil
        self.TradeName      = trade         != nil ? trade  : nil
        self.Unit           = unit          != nil ? unit   : nil
        self.Uses           = uses          != nil ? uses   : nil
    }
}
