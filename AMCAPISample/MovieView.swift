//
//  MovieView.swift
//  AMCAPISample
//
//  Created by Michael A. Crawford on 9/9/21.
//

import AMCAPI
import SwiftUI

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct ScrollView<Content: View>: View {
    let axes: Axis.Set
    let showsIndicators: Bool
    let offsetChanged: (CGPoint) -> Void
    let content: Content

    init(axes: Axis.Set = .vertical,
         showsIndicators: Bool = true,
         offsetChanged: @escaping (CGPoint) -> Void = { _ in },
         @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.offsetChanged = offsetChanged
        self.content = content()
    }

    var body: some View {
        SwiftUI.ScrollView(axes, showsIndicators: showsIndicators) {
            GeometryReader { geometry in
                Color.clear.preference(key: ScrollOffsetPreferenceKey.self,
                                       value: geometry.frame(in: .named("scrollView")).origin)
            }.frame(width: 0, height: 0)
            content
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: offsetChanged)
    }
}

@MainActor
struct MovieView: View {
    var movieList: MovieList

    @State private var isMoviePlayerPresented = false
    @State private var movieURL: URL?
    @State private var searchText = ""

    private var gridItemLayout = [
        GridItem(.adaptive(minimum: 195, maximum: 195), spacing: 0)
    ]

    private var searchResults: [AMCAPI.MovieModel] {
        if searchText.isEmpty {
            return movieList.items
        } else {
            return movieList.items.filter { $0.sortableName.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    ScrollView(axes: .vertical, showsIndicators: true) {
                        let width = geometry.size.width / 2
                        let height = width * 1.5
                        let gridItem = GridItem(.adaptive(minimum: width, maximum: width), spacing: 0)
                        LazyVGrid(columns: Array(repeating: gridItem, count: 1), spacing: 0) {
                            ForEach(searchResults) { movie in
                                if let url = movie.thumbnailImageURL {
                                    RemoteImage(url: url, resizedTo: CGSize(width: width, height: height))
                                        .frame(width: width, height: height)
                                        .gesture(TapGesture().onEnded({ _ in
                                            if let movieURL = URL(string: movie.media.trailerMp4) {
                                                self.movieURL = movieURL
                                            }
                                        }))
                                } else {
                                    ZStack {
                                        Image(systemName: "multiply.circle")
                                            .frame(width: width, height: height)
                                            .font(.largeTitle)
                                        VStack {
                                            Spacer()
                                            Text(movie.name).font(.headline)
                                            Spacer()
                                            Text("No Image").font(.headline)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                        .animation(.easeInOut(duration: 0.2), value: searchResults)
                        .searchable(text: $searchText)
                    }
                    .navigationTitle(movieList.title)
                    .sheet(isPresented: Binding(get: {
                        movieURL != nil
                    }, set: { _ /* booleanValue */ in
                        // Intentionally left blank
                    })) {
                        MoviePlayerView(url: $movieURL)
                    }
                    .refreshable {
                        movieList.fetch()
                    }

                    if case MovieList.FetchState.isFetching = movieList.fetchState {
                        ActivityIndicatorView()
                    }
                }
            }
        }
        .alert("Error fetching data!", isPresented: Binding(get: {
            movieList.error != nil
        }, set: { _ /* newValue */ in
            // Intentionally left empty since we don't want to reset the error property until the user acknowledges the error.
        }), actions: {
            Button("OK") {
                movieList.error = nil
            }
        }, message: {
            Text((movieList.error == nil ? "No details" : String(describing: movieList.error!)))
        })
        .onAppear {
            movieList.fetch()
        }
    }

    init(movieList: MovieList) {
        self.movieList = movieList
    }
}
