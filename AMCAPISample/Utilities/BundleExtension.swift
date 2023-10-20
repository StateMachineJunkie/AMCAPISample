//
//  BundleExtension.swift
//  AMCAPISample
//
//  Created by Michael A. Crawford on 10/18/21.
//

import Foundation

extension Bundle {
    var loggingId: String {
        if let id = Bundle.main.bundleIdentifier {
            return id
        } else {
            return Bundle.main.description
        }
    }
}
