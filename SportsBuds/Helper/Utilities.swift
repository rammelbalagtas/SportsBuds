//
//  Utilities.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-08.
//

import Foundation
import UIKit

class Utilities {
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
