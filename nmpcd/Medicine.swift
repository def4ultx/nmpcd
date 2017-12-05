//
//  Medicine.swift
//  nmpcd
//
//  Created by bally on 12/5/17.
//  Copyright © 2017 bally. All rights reserved.
//

import Foundation
class Medicine {
    var medStrenght: Int!
    var medName: String!
    var medUses: String!
    var medUnit: String!
    var medStorage: String!
    var medDosageForm: String!
    var medPrecaution: String!
    var medAdministration: String!
    var barcodeNo: String!
    var genericName: String!
    init?(barcode: String?, usage: String?, name: String?) {
        if (barcode!.isEmpty || usage!.isEmpty || name!.isEmpty) {
            return nil
        }
    }
}
