//
//  LearningView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI

struct LearningView: View {
    
    let quote: AnimeQuote
    
    var dummieQuote: AnimeQuote = AnimeQuote(japanese: ["天上天下", "唯我独尊"], pronunciation: ["텐조오텐게", "유이가도쿠손"], korean: ["천상천하", "유아독존"], evaluation: Evaluation(pronunciationScore: 0.0, pronunciationPass: false, intonationScore: 0.0, intonationPass: false, speedScore: 0.0, speedPass: false), timemark: [0.01, 1.6], voicingTime: 0.0, audiofile: "JUJ005.m4a", youtubeID: "cJVeIwP_HoQ", youtubeStartTime: 90, youtubeEndTime: 115)
    
    @State var isCounting: Bool = true
    @State var countdown = 4 // 초기 카운트 설정
    
    @State private var timer: Timer? = nil       // 타이머 객체
    @State private var timerCount: Double = 0.0 // 초기 타이머 설정 (초 단위)
    @State private var isRunning: Bool = false   // 타이머 상태
    
    @StateObject private var sttManager = STTManager()
    
    var body: some View {
        ZStack{
            VStack {
                Spacer()
                
                HStack{
                    Image(systemName: "timer.circle.fill")
                        .foregroundStyle(.blue)
                    Text(String(format: "%.2f", timerCount)) // 소수점 2자리까지 시간 표시
                        .font(.system(size: 25, weight: .bold))
                }
                .padding(.bottom, 48)
                
                if dummieQuote.japanese.count >= 5 {
                    let halfIndex = dummieQuote.japanese.count / 2
                    
                    // 두 개의 HStack으로 나누어 텍스트 표시
                    VStack {
                        HStack {
                            ForEach(0..<halfIndex, id: \.self) { index in
                                VStack(spacing:13) {
                                    Text(dummieQuote.korean[index])
                                        .font(.system(size:18))
                                    Text(dummieQuote.japanese[index])
                                        .font(.system(size:18))
                                    Text(dummieQuote.pronunciation[index])
                                        .font(.system(size:14))
                                }
                                .bold()
                                .padding(5)
//                                .background{
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .stroke(isHighlighted(wordIndex: index, timeByWord: timeByWord) ? Color.red : Color.clear, lineWidth: 2.0)
//                                    }
//                                }
                                Divider().frame(height: 80)
                            }
                        }
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.ppBlue)
                        }
                        HStack {
                            ForEach(halfIndex..<dummieQuote.japanese.count, id: \.self) { index in
                                VStack(spacing:13) {
                                    Text(dummieQuote.korean[index])
                                        .font(.system(size:18))
                                    Text(dummieQuote.japanese[index])
                                        .font(.system(size:18))
                                    Text(dummieQuote.pronunciation[index])
                                        .font(.system(size:14))
                                }
                                .bold()
                                .padding(5)
//                                .background{
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .stroke(isHighlighted(wordIndex: index, timeByWord: timeByWord) ? Color.red : Color.clear, lineWidth: 2.0)
//                                    }
//                                }
                                Divider().frame(height: 80)
                            }
                        }
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.ppBlue)
                        }
                    }
                    
                } else {
                    // 길이가 5 미만일 때 기존 방식
                    HStack {
                        ForEach(dummieQuote.japanese.indices, id: \.self) { index in
                            VStack {
                                Text(dummieQuote.japanese[index])
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text(dummieQuote.korean[index])
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(dummieQuote.pronunciation[index])
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .padding(5)
//                            .background{
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(isHighlighted(wordIndex: index, timeByWord: timeByWord) ? Color.red : Color.clear, lineWidth: 2.0)
//                                }
//                            }
                            Divider().frame(height: 30)
                        }
                    }
                }
                
                Button(action:{
//                    Router.shared.navigate(to: .result(score: 90))
                    sttManager.stopRecording()
                    stopTimer()
                }, label:{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 220, height:60)
                        .foregroundStyle(.blue)
                        .overlay {
                            Text("완료")
                                .foregroundStyle(.white)
                                .bold()
                        }
                })
                .padding(.top, 90)
                Spacer()
                
            }
            
            if isCounting {
                Color.black.opacity(0.7) // 어두운 오버레이 배경
                    .edgesIgnoringSafeArea(.all)
                
                Text(countdown == 1 ? "Start!" : "\(countdown-1)") // 카운트다운 숫자
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.white)
                    .onAppear {
                        startCountdown() // 뷰가 나타나면 카운트다운 시작
                    }
            }
        }
        .onAppear {
            sttManager.startRecording() // 뷰에 진입 시 녹음 시작
        }
        .onDisappear {
            sttManager.stopRecording() // 뷰에서 벗어날 때 녹음 중지
        }
        .onChange(of: isCounting) { newValue in
            if isCounting == false {
                startTimer()
            }
        }
    }
    
    private func startCountdown() {
        // 1초마다 카운트다운 감소
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
            } else {
                // 카운트가 끝나면 오버레이를 제거하고 타이머 종료
                self.isCounting = false
                timer.invalidate()
            }
        }
    }
    
    // 0에서 증가하는 타이머 시작 함수
    private func startTimer() {
        if isRunning { return } // 이미 타이머가 실행 중이면 종료
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            timerCount += 0.01
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()  // 타이머 중지
        timer = nil          // 타이머 객체 초기화
        isRunning = false
    }
    
    private func isHighlighted(wordIndex: Int, timeByWord: [Double], timerCount: Double) -> Bool {
        guard wordIndex < timeByWord.count - 1 else { return false }
        
        let startTime = timeByWord[wordIndex]
        let endTime = timeByWord[wordIndex + 1]
        
        return timerCount >= startTime && timerCount < endTime
    }

}

//#Preview {
//    LearningView(quote: AnimeQuote(japanese: ["長い間", "くそ", "お世話に", "なりました"], pronunciation: ["나가이아이다", "쿠소", "오세와니", "나리마시타"], korean: ["오랜시간", "빌어먹게", "신세를", "졌습니다"], evaluation: Evaluation(pronunciationScore: 0.0, pronunciationPass: false, intonationScore: 0.0, intonationPass: false, speedScore: 0.0, speedPass: false), timemark: [1.9, 3.0, 3.9, 4.6], audiofile: "ONP001.m4a"))
//}
