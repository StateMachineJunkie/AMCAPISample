//
//  ContentView.swift
//  AMCAPISample
//
//  Created by Michael Crawford on 7/7/21.
//

import SwiftUI

struct ContentView: View {
    // Allocation of the view-models needed for each tab.
    @StateObject var comingSoonMovieList = MovieList(filter: .comingSoon)
    @StateObject var nowPlayingMovieList = MovieList(filter: .nowPlaying)
    // Remember the last tab selected by the user, between app sessions.
    @SceneStorage("selectedTab") var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            MovieView(movieList: nowPlayingMovieList).tabItem {
                Label("Now Playing", systemImage: "film.fill")
            }
            .tag(0)
            MovieView(movieList: comingSoonMovieList).tabItem {
                Label("Coming Soon", systemImage: "ticket.fill")
            }
            .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
