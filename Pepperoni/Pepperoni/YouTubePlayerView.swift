//
//  YouTubePlayerView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/29/24.
//

import SwiftUI
import YouTubeiOSPlayerHelper

struct YouTubePlayerView: UIViewRepresentable {
    var videoID: String
    var startTime: Int // 특정 초부터 재생

    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        
        let playerVars: [String: Any] = [
            "playsinline": 1,
            "autoplay": 1,
            "rel": 0,
            "start": startTime // 재생 시작 시간
        ]

        playerView.load(withVideoId: videoID, playerVars: playerVars)
        return playerView
    }

    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        // 업데이트 로직
    }
}
