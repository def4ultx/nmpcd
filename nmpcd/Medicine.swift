//
//  Medicine.swift
//  nmpcd
//
//  Created by bally on 12/5/17.
//  Copyright © 2017 bally. All rights reserved.
//

import Foundation
class Medicine {
    var Barcode: String!
    var Usage: String!
    var Name: String!
    init?(barcode: String?, usage: String?, name: String?) {
        if (barcode!.isEmpty || usage!.isEmpty || name!.isEmpty) {
            return nil
        }
        self.Barcode = barcode!
        self.Usage = usage!
        self.Name = name!
    }
}
