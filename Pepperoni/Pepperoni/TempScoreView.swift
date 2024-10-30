//
//  TempScoreView.swift
//  Pepperoni
//
//  Created by Woowon Kang on 10/30/24.
//

import SwiftUI

struct TempScoreView: View {
    
    // Model의 AnimeQuote 임시 변수
    var japanese = ["長い間", "くそ", "お世話に", "なりました"]
    var pronunciation = ["나가이아이다", "쿠소", "오세와니", "나리마시타"]
    var korean = ["오랜시간", "빌어먹게", "신세를", "졌습니다"]
    //var evaluation: Evaluation // 각 요소별 점수 및 통과 여부
    var timemark = [1.9, 3.0, 3.9, 4.6]
    var audiofile = "tempAudio.m4a"
    @State var isCompleted = false // 별 3개가 달성되었는지
    
    // Model의 Evaluation 임시 변수
    var pronunciationScore = 0.0
    var pronunciationPass = false
    var speedScore = 0.0
    var speedPass = false
    
    @StateObject private var sttManager = STTManager()
    
    var body: some View {
        VStack {
            HStack {
                Text("발음")
                Text("속도")
            }
            
        }
    }
}

#Preview {
    TempScoreView()
}
