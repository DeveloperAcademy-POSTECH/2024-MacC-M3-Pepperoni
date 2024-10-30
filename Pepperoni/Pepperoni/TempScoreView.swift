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
    
    // 하이큐 AnimeQuote 임시 변수
    var japanese2 = ["才能は", "開花させる", "もの", "センスは", "磨く", "もの"]
    var pronunciation2 = ["사이노우와", "카이카사세루", "모노", "센스와", "미가쿠", "모노"]
    var korean2 = ["재능은", "발휘하는", "것", "센스는", "연마하는", "것"]
    var timemark2 = [2.0, 2.5, 3.3, 5.0, 5.4, 6.0]
    let timeLength2: Double = 7.0 // 하이큐 음원 길이
    
    // Model의 Evaluation 임시 변수
    @State private var pronunciationScore = 0.0
    var pronunciationPass = false
    @State private var speedScore = 0.0
    var speedPass = false
    
    @State private var voicingTime: Double = 0.0
    
    @StateObject private var sttManager = STTManager()
    
    var body: some View {
        VStack {
            // 의미
            HStack {
                ForEach(korean2, id: \.self) { meaning in
                    Text(meaning)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 일본어 단어
            HStack {
                ForEach(japanese2, id: \.self) { word in
                    Text(word)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 발음
            HStack {
                ForEach(pronunciation2, id: \.self) { pronunciation in
                    Text("\(pronunciation)")
                        .frame(maxWidth: .infinity)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("발음 정확도: \(pronunciationScore, specifier: "%.1f")%")
                Text("속도 정확도: \(speedScore, specifier: "%.1f")%")
            }
            .font(.title2)
            .padding()
            
            // STT 표기
            TextEditor(text: $sttManager.recognizedText)
                .disabled(true)
                .lineLimit(2)
            
            if let startTime = sttManager.startTime, let endTime = sttManager.endTime {
                Text("음성 시작 시간: \(String(format: "%.2f", startTime))초")
                Text("음성 끝 시간: \(String(format: "%.2f", endTime))초")
                Text("총 길이: \(String(format: "%.2f", endTime - startTime))초")
            } else {
                Text("음성을 녹음하고 분석하세요.")
                    .foregroundColor(.gray)
            }
            
            // 녹음 버튼
            Button(action: {
                if sttManager.isRecording {
                    sttManager.stopRecording()
                    
                } else {
                    sttManager.startRecording()
                }
            }) {
                Text(sttManager.isRecording ? "Stop Recording" : "Start Recording")
                    .foregroundColor(.white)
                    .padding()
                    .background(sttManager.isRecording ? Color.red : Color.blue)
                    .cornerRadius(10)
            }
            
            // 채점 버튼
            Button(action: {
                pronunciationScore = calculatePronunciation(original: japanese2, sttText: sttManager.recognizedText)
                
                voicingTime = sttManager.voicingTime!
                print("길이 출력: \(voicingTime)")
                speedScore = calculateSpeededPronunciation(originalLength: timeLength2, sttVoicingTime: voicingTime)
                
            }) {
                Text("채점하기")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    TempScoreView()
}
