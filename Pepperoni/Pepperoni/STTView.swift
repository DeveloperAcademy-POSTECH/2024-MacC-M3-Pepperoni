//
//  STTView.swift
//  Pepperoni
//
//  Created by Woowon Kang on 10/28/24.
//

import SwiftUI

struct STTView: View {
    @StateObject private var sttManager = STTManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Japanese Speech-to-Text")
                .font(.title)
            
            Text("")
            
            // sttManager의 recognizedText를 사용하여 텍스트 표시
            Text(sttManager.recognizedText)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
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
