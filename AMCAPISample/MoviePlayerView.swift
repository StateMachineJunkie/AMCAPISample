// 
// MoviePlayerView.swift
// AMCAPISample
//
// Created by Michael Crawford on 9/29/21.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import AVKit
import SwiftUI

struct MoviePlayerView: View {
    @Binding var url: URL?

    private let player = AVPlayer()

    var body: some View {
        VStack {
            if let url {
                VideoPlayer(player: player)
            } else {
                Text("Trailer unavailable!")
            }
            Button("Dismiss") {
                url = nil
            }
        }
        .onAppear {
            if let url {
                let playerItem = AVPlayerItem(url: url)
                player.replaceCurrentItem(with: playerItem)
                player.play()
            }
        }
        .onDisappear {
            player.pause()
        }
    }
}

struct MoviePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        @State var movieURL: URL? = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        MoviePlayerView(url: $movieURL)
    }
}
