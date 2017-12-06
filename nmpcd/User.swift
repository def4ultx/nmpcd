//
//  User.swift
//  nmpcd
//
//  Created by bally on 12/6/17.
//  Copyright © 2017 bally. All rights reserved.
//

import Foundation

class User {
    var email: String!
    var username: String!
    var fullname: String!
    init(email: String, username: String, fullname: String) {
        self.email = email
        self.username = username
        self.fullname = fullname
    }
}
