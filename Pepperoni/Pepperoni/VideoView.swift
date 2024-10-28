//
//  VideoView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/29/24.
//

import SwiftUI

struct VideoView: View {
    var body: some View {
        VStack {
            VideoWrapper(videoID: "E-FHHWeYhAg", startTime: 20)
                .frame(height: 300)
                .padding()
        }
    }
}

#Preview {
    VideoView()
}
