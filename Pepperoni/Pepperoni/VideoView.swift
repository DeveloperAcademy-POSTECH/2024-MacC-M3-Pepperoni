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
            VideoWrapper(videoID: "E-FHHWeYhAg")
                .frame(height: 300)
                .cornerRadius(10)
                .padding()
        }
    }
}

#Preview {
    VideoView()
}
