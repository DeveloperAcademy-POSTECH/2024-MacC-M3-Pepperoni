//
//  STTView.swift
//  Pepperoni
//
//  Created by Woowon Kang on 10/28/24.
//

import SwiftUI

// MARK: - 예시 뷰
// STT, 발음 체크 사용예시 뷰 입니다.
// 참고만 하세요

struct STTView: View {
    @StateObject private var sttManager = STTManager()
    
    let meanings = ["오랜시간", "빌어먹게", "신세를", "졌습니다"]
    let words = ["長い間", "くそ", "お世話に", "なりました"]
    let pronunciations = ["나가이아이다", "쿠소", "오세와니", "나리마시타"]
    @State var isCorrect = [false, false, false, false]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Japanese Speech-to-Text")
                .font(.title)
            
            // 의미
            HStack {
                ForEach(meanings, id: \.self) { meaning in
                    Text(meaning)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 일본어 단어
            HStack {
                ForEach(words, id: \.self) { word in
                    Text(word)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 발음
            HStack {
                ForEach(pronunciations, id: \.self) { pronunciation in
                    Text("\(pronunciation)")
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 발음 체크
            HStack {
                ForEach(0..<words.count, id: \.self) { index in
                    if sttManager.recognizedText.contains(words[index]) {
                        Text("정확함")
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("다름")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            
            // 녹음 텍스트 표시 (녹음 종료 후 표시되는 finalText)
            TextEditor(text: sttManager.isRecording ? $sttManager.recognizedText : $sttManager.finalText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
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
        }
        .padding()
    }
}

#Preview {
    STTView()
}
