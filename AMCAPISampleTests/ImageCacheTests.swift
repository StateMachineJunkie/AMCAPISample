//
//  ImageCacheTests.swift
//  AMCAPISampleTests
//
//  Created by Michael A. Crawford on 10/3/21.
//

import XCTest
@testable import AMCAPISample

class ImageCacheTests: XCTestCase {

    private let countLimit: Int = 3

    private let url1 = URL(string: "https://cdellc/image/1")!
    private let url2 = URL(string: "https://cdellc/image/2")!
    private let url3 = URL(string: "https://cdellc/image/3")!
    private let url4 = URL(string: "https://cdellc/image/4")!
    private let image1 = UIImage(systemName: "person")!
    private let image2 = UIImage(systemName: "trash")!
    private let image3 = UIImage(systemName: "folder")!
    private let image4 = UIImage(systemName: "doc")!

    private var evictedImageClosure: ((UIImage) -> Void)!
    private var imageCache: ImageCache!

    override func setUpWithError() throws {
        imageCache = ImageCache(countLimit: countLimit)
    }

    override func tearDownWithError() throws {
        imageCache = nil
    }

    func testImageCacheHit() throws {
        XCTAssertNoThrow(imageCache[url1] = image1)
        XCTAssertEqual(imageCache[url1], image1)
    }

    func testImageCacheMiss() throws {
        XCTAssertNil(imageCache[url1])
        XCTAssertNoThrow(imageCache[url2])
        XCTAssertNil(imageCache[url1])
    }

    func testImageCacheCollision() throws {
        XCTAssertNoThrow(imageCache[url1] = image1)
        XCTAssertNoThrow(imageCache[url1] = image2)
        XCTAssertNotEqual(imageCache[url1], image1)
        XCTAssertEqual(imageCache[url1], image2)
    }

    func testImageCacheCountLimit() throws {
        imageCache.delegate = self
        let expectation = XCTestExpectation(description: "Waiting for cache eviction!")

        evictedImageClosure = { image in
            expectation.fulfill()
        }

        XCTAssertNoThrow(imageCache[url1] = image1)
        XCTAssertNoThrow(imageCache[url2] = image2)
        XCTAssertNoThrow(imageCache[url3] = image3)

        XCTAssertEqual(imageCache[url1], image1)
        XCTAssertEqual(imageCache[url2], image2)
        XCTAssertEqual(imageCache[url3], image3)

        DispatchQueue.global().async {
            XCTAssertNoThrow(self.imageCache[self.url4] = self.image4)
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

extension ImageCacheTests: ImageCacheDelegate {
    func imageCache(_ imageCache: ImageCache, willEvictImage image: UIImage) {
        self.evictedImageClosure(image)
    }
}
