//
//  VideoView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/29/24.
//

import SwiftUI

struct VideoTestView: View {
    var body: some View {
        VStack {
            YouTubePlayerView(videoID: "CGREMa2xFBk", startTime: 20, endTime: 25)
                .frame(height: 300)
                .padding()
        }
    }
}

#Preview {
    VideoTestView()
}
