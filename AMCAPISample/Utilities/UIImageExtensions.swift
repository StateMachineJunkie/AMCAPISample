// 
// UIImageExtensions.swift
// AMCAPISample
//
// Created by Michael Crawford on 9/27/21.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

extension UIImage {
    /// Resize image.
    ///
    /// Redraw image using the given size constraint. If the given size constraint matches the current size for this image, no work will be performed and the original
    /// image will be returned to the caller.
    ///
    /// - Parameter size: Desired image size in points.
    /// - Returns: A new ``UIImage`` containing the original image redraw to fit the given size constraints.
    func resized(to size: CGSize) -> UIImage {
        guard size != .zero, size != self.size else { return self }
        return UIGraphicsImageRenderer(size: size).image { context in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
