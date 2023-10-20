// 
// ModelCache.swift
// AMCAPISample
//
// Created by Michael Crawford on 10/18/21.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import AMCAPI
import Foundation

struct ModelCache<Model: Codable & Equatable>: Codable, Equatable {
    let model: Model
    let timestamp: Date

    /// Fetch the Model value from the file system.
    ///
    /// - Throws: `Data` loading or PLIST decoding error.
    /// - Returns: `CachedMovies` value.
    /// - Parameter path: Location in the file system where this value should be read from.
    static func fetch(from path: String) throws -> ModelCache<Model> {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        return try decoder.decode(ModelCache<Model>.self, from: data)
    }

    /// Store this `ModelCache` value to the file system as a property list.
    ///
    /// - Throws: In the case of an unknown write error `NSFileWriteUnknown` is thrown. If the property list encoding fails a PLIST
    ///           specific error will be thrown.
    /// - Parameter path: Location in the file system where this value should be written.
    func store(at path: String) throws {
        let encoder = PropertyListEncoder()
        let data = try encoder.encode(self)

        if FileManager.default.createFile(atPath: path, contents: data) == false {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFileWriteUnknownError)
        }
    }
}
