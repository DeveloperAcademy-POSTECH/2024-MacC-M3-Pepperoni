//
//  LearningView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI

struct LearningView: View {
    
    let quote: AnimeQuote
    
    var body: some View {
        VStack {
            Text("LearningView")
            Text("한국어 발음: \(quote.korean)")
            
            Button("Finish Learning") {
                Router.shared.navigate(to: .result(score: 90))
            }
        }
    }
}

#Preview {
    LearningView(quote: AnimeQuote(japanese: ["長い間", "くそ", "お世話に", "なりました"], pronunciation: ["나가이아이다", "쿠소", "오세와니", "나리마시타"], korean: ["오랜시간", "빌어먹게", "신세를", "졌습니다"], evaluation: Evaluation(pronunciationScore: 0.0, pronunciationPass: false, intonationScore: 0.0, intonationPass: false, speedScore: 0.0, speedPass: false), timemark: [1.9, 3.0, 3.9, 4.6], audiofile: "ONP001.m4a"))
}
