//
//  VideoWrapper.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/29/24.
//

import SwiftUI
import WebKit

struct VideoWrapper: UIViewRepresentable {
    let videoID: String
    let startTime: Int // 재생 시작 시간(초 단위)

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let embedHTML = """
        <html>
        <body style="margin:0;padding:0;">
        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\(videoID)?start=\(startTime)&playsinline=1&autoplay=1&rel=0" frameborder="0" allowfullscreen></iframe>
        </body>
        </html>
        """
        uiView.loadHTMLString(embedHTML, baseURL: nil)
    }
}
