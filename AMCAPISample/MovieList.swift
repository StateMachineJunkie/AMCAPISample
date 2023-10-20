//
//  MovieList.swift
//  AMCAPISample
//
//  Created by Michael A. Crawford on 9/9/21.
//

import AMCAPI
import Combine
import Foundation
import os.log

protocol AMCMovieAPI {
    func fetchAllMovies(pageNumber: Int, pageSize: Int) -> AnyPublisher<AMCAPI.MoviesModel, Swift.Error>
    func fetchComingSoonMovies(pageNumber: Int, pageSize: Int) -> AnyPublisher<AMCAPI.MoviesModel, Swift.Error>
    func fetchNowPlayingMovies(pageNumber: Int, pageSize: Int) -> AnyPublisher<AMCAPI.MoviesModel, Swift.Error>
}

extension AMCAPI: AMCMovieAPI {}

@MainActor
class MovieList: ObservableObject {
    enum Filter { case comingSoon, nowPlaying }

    enum FetchState: Equatable {
        case idle(model: AMCAPI.MoviesModel?)
        case isFetching(pageNumber: Int)
    }

    typealias FetchAPI = (Int, Int) -> AnyPublisher<AMCAPI.MoviesModel, Swift.Error>

    private let cachePath: String
    private let fetchAPI: FetchAPI
    private var fetchDate: Date?
    private var logger = Logger(subsystem: "\(Bundle.main.loggingId)", category: "App")
    private var movieAPI: AMCMovieAPI
    private var pageSize: Int
    private var subscriptions = Set<AnyCancellable>()

    @Published private(set) var count: Int = 0  // FIXME: This property may be redundant due to item array.

    @Published var error: Error?                // Intended for use with two-way binding; used for displaying alerts.

    @Published private(set) var fetchState: FetchState = .idle(model: nil) {
        didSet {
            logger.debug("fetchState: \(oldValue) -> \(self.fetchState)")

            guard oldValue != fetchState else { return }

            switch fetchState {
            case .idle(model: let model):
                guard let newModel = model  else { return }
                fetchDate = Date()

                if newModel.pageNumber == 1 {
                    // We successfully fetched the first page of data. Overwrite existing internal state.
                    count = newModel.count
                    items = newModel.embedded.movies
                } else {
                    // We successfully fetched an additional page of data. Append to existing internal state.
                    count += newModel.count
                    items.append(contentsOf: newModel.embedded.movies)
                }

                lastFetchedPageNumber = newModel.pageNumber

                do {
                    let cachedMovies = ModelCache<[AMCAPI.MovieModel]>(model: items, timestamp: fetchDate!)
                    try cachedMovies.store(at: cachePath)
                } catch {
                    logger.fault("Failed to write cache of movie data to disk. \(error.localizedDescription)")
                }
            case .isFetching(pageNumber: let pageNumber):
                // Reset the error state before proceeding with a new fetch operation.
                error = nil
                // Now, get the data.
                fetchMovies(pageNumber: pageNumber)
            }
        }
    }

    @Published private(set) var items: [AMCAPI.MovieModel] = []
    private(set) var lastFetchedPageNumber: Int = 0
    private var timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var title: String

    init(pageSize: Int = 10, filter: Filter? = nil, movieAPI: AMCMovieAPI = AMCAPI.shared) {
        AMCAPI.shared.setVendorAuthKey("[--Go to http://developers.amctheatres.com--]")

        // First setup operation parameters for fetching movie information.
        self.movieAPI = movieAPI
        self.pageSize = pageSize

        switch filter {
        case .comingSoon:
            cachePath = FileManager.cachedComingSoonMoviesPath()
            fetchAPI = movieAPI.fetchComingSoonMovies
            title = "Coming Soon"
        case .nowPlaying:
            cachePath = FileManager.cachedNowPlayingMoviesPath()
            fetchAPI = movieAPI.fetchNowPlayingMovies
            title = "Now Playing"
        case .none:
            cachePath = FileManager.cachedMoviesPath()
            fetchAPI = movieAPI.fetchAllMovies
            title = "All Movies"
        }

        // Next, load existing movie data from the file-system cache.
        if let cachedMovies = try? ModelCache<[AMCAPI.MovieModel]>.fetch(from: cachePath) {
            fetchDate = cachedMovies.timestamp
            items = cachedMovies.model
        }

        // Finally, setup the periodic function for fetching and caching data automatically.
        timer.receive(on: DispatchQueue.main).sink { [weak self] _ in
            guard let self else { return }
            guard self.error == nil else { return }
            guard case .idle = self.fetchState else { return }
            // Check to see if we've crossed over into a new day. If so, pull the latest data, cache it,
            // and then signal the UI to update itself.
            if let lastFetchDate = self.fetchDate, Calendar.current.isDateInToday(lastFetchDate) { return }
            // Start over with the first page.
            self.fetchState = .isFetching(pageNumber: 1)
        }.store(in: &subscriptions)
    }

    /// Request that movie data be fetched from the beginning of the listing (first page).
    /// -Note: If a fetch is already in-progress, this request will be ignored and the results of the in-progress
    ///        request will be published when completed.
    func fetch() {
        guard case .idle = fetchState else { return }
        fetchState = .isFetching(pageNumber: 1)
    }

    /// Fetch movie data by page number
    ///
    /// This internal method is intended to only be invoked from a change to the `fetchState` property and should
    /// not be called directly.
    /// - Parameter pageNumber: The page of movie data to be requested from the AMCAPI.
    private func fetchMovies(pageNumber: Int = 1) {
        fetchAPI(pageNumber, pageSize)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                if case let .failure(error) = completion {
                    self.fetchState = .idle(model: nil)
                    self.error = error
                }
            } receiveValue: { [unowned self] model in
                self.fetchState = .idle(model: model)
            }
            .store(in: &subscriptions)
    }
}

private extension FileManager {
    static func cachedMoviesPath() -> String {
        NSHomeDirectory() + "/Library/Caches/CachedMovies.plist"
    }

    static func cachedComingSoonMoviesPath() -> String {
        NSHomeDirectory() + "/Library/Caches/CachedComingSoonMovies"
    }

    static func cachedNowPlayingMoviesPath() -> String {
        NSHomeDirectory() + "/Library/Caches/CachedNowPlayingMovies"
    }
}

extension MovieList.FetchState: CustomStringConvertible {
    /// For debugging purposes, I want to monitor state transitions in the console. Conforming to `CustomStringConvertible`
    /// make this possible in combination with the new `Logger` API for iOS 15.
    var description: String {
        switch self {
        case let .idle(model: model):
            if let model = model {
                return "Is idle with \(model.embedded.movies.count) movie(s)."
            } else {
                return "Is idle with zero movies."
            }
        case let .isFetching(pageNumber: pageNumber):
            return "Is fetching page \(pageNumber)."
        }
    }
}
