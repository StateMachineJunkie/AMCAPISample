//
//  RemoteImage.swift
//  AMCAPISample
//
//  Created by Michael A. Crawford on 9/11/21.
//

import Combine
import SwiftUI

/// View that automatically loads and displays a remote image downloaded from a given URL. Normally this would be handled
/// by the new `AsyncImage` view provided with SwiftUI version 3. However, that view does not support caching and is therefore
/// unsuitable for use in my application. The caching functionality is accomplished by using `ImageLoader` for implementation.
/// - SeeAlso: ``ImageLoader``
struct RemoteImage: View {
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        private var subscriptions = Set<AnyCancellable>()

        var image: UIImage?
        @Published var state = LoadState.loading
        var url: URL

        init(url: URL, resizedTo size: CGSize = .zero) {
            self.url = url
            ImageLoader.shared.loadImage(from: url, resizedTo: size).sink { [weak self] image in

                if image == image {
                    self?.image = image
                    self?.state = .success
                } else {
                    self?.state = .failure
                }

                self?.objectWillChange.send()
            }.store(in: &subscriptions)
        }
    }

    @ObservedObject private var loader: Loader
    private var loading: Image
    private var failure: Image

    var body: some View {
        selectImage()
            .resizable()
    }

    /// Initialize `RemoteImage` with an image URL.
    /// - Parameters:
    ///   - url: Identifies the remote image to be downloaded.
    ///   - size: The desired size in points of the resulting image. This parameter has a default value of `CGSize.zero`.
    ///           If the default value is used, the resulting image will be cached and then returned in its original dimensions.
    ///   - loading: Image to be displayed while the image loading is in progress.
    ///   - failure: Image to be displayed if the image loading operation fails.
    init(url: URL,
         resizedTo size: CGSize = .zero,
         loading: Image = Image(systemName: "photo"),
         failure: Image = Image(systemName: "multiply.circle")) {
        self.loading = loading
        self.failure = failure
        self.loader = Loader(url: url, resizedTo: size)
    }

    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = loader.image {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}
