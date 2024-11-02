//
//  LearningView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI

struct LearningView: View {
    
    let quote: AnimeQuote
    
//    var dummieQuote: AnimeQuote = AnimeQuote(japanese: ["天上天下", "唯我独尊"], pronunciation: ["텐조오텐게", "유이가도쿠손"], korean: ["천상천하", "유아독존"], evaluation: Evaluation(pronunciationScore: 0.0, pronunciationPass: false, intonationScore: 0.0, intonationPass: false, speedScore: 0.0, speedPass: false), timemark: [0.01, 1.6], voicingTime: 1.9, audiofile: "JUJ005.m4a", youtubeID: "cJVeIwP_HoQ", youtubeStartTime: 90, youtubeEndTime: 115)
    
    @State var isCounting: Bool = true
    @State var countdown = 4 // 초기 카운트 설정
    
    @State private var timer: Timer? = nil       // 타이머 객체
    @State private var timerCount: Double = 0.0 // 초기 타이머 설정 (초 단위)
    @State private var isRunning: Bool = false   // 타이머 상태
    
    @StateObject private var sttManager = STTManager()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                HStack{
                    Image(systemName: "timer.circle.fill")
                        .foregroundStyle(.blue)
                    Text(String(format: "%.2f", timerCount)) // 소수점 2자리까지 시간 표시
                        .font(.system(size: 25, weight: .bold))
                }
                .padding(.bottom, 48)
                
                // TODO: dummieQuote -> quote로 변경
                if quote.japanese.count >= 5 {
                    let halfIndex = quote.japanese.count / 2
                    
                    // 두 개의 HStack으로 나누어 텍스트 표시
                    VStack {
                        HStack {
                            ForEach(0..<halfIndex, id: \.self) { index in
                                VStack(spacing:13) {
                                    Text(quote.korean[index])
                                        .font(.system(size:18))
                                    Text(quote.japanese[index])
                                        .font(.system(size:18))
                                    Text(quote.pronunciation[index])
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
                            ForEach(halfIndex..<quote.japanese.count, id: \.self) { index in
                                VStack(spacing:13) {
                                    Text(quote.korean[index])
                                        .font(.system(size:18))
                                    Text(quote.japanese[index])
                                        .font(.system(size:18))
                                    Text(quote.pronunciation[index])
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
                        ForEach(quote.japanese.indices, id: \.self) { index in
                            VStack {
                                Text(quote.japanese[index])
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text(quote.korean[index])
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(quote.pronunciation[index])
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
                    Router.shared.navigate(to: .result(quote: quote))
                    sttManager.stopRecording()
                    stopTimer()
                    grading()
                }, label:{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 220, height:60)
                        .foregroundStyle(.pointBlue)
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
                
                Text(countdown == 1 ? "Start!" : "\(countdown - 1)") // 카운트다운 숫자
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.white)
                    .onAppear {
                        startCountdown() // 뷰가 나타나면 카운트다운 시작
                    }
            }
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
                
                // 타이머가 끝난 후에 비동기로 STT 시작
                DispatchQueue.main.async {
                    sttManager.startRecording() // 타이머 종료 후 STT 녹음 시작
                }
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
    
    // 채점
    private func grading() {
        // 발음과 속도를 채점합니다.
        quote.evaluation.pronunciationScore = calculatePronunciation(original: quote.japanese, sttText: sttManager.recognizedText)
        //TODO: 억양 채점 여기에 넣어주세요!
        quote.evaluation.speedScore = calculateVoiceSpeed(
            originalLength: quote.voicingTime,
            sttVoicingTime: sttManager.voicingTime!)
        
        print("원본 일본어: \(quote.japanese)")
        print("원본 속도: \(quote.voicingTime)")
        print("사용자 속도: \(sttManager.voicingTime!)")
        
        // 80점이 넘으면 pass
        if quote.evaluation.pronunciationScore < 80 {
            quote.evaluation.pronunciationPass = false
        } else {
            quote.evaluation.pronunciationPass = true
        }
        
        if quote.evaluation.speedScore < 80 {
            quote.evaluation.speedPass = false
        } else {
            quote.evaluation.speedPass = true
        }
        
        // 임시로 발음, 속도가 모두 80점이 넘었다면 높낮이도 pass
        // 유튜브 영상 띄우기 위함
        //TODO: 별 3개 채웠는데 다시 시도 했을때 0점이면 억양의 별은 채워져 있음 억양추가시 수정 필요
        if quote.evaluation.pronunciationPass && quote.evaluation.speedPass {
            quote.evaluation.intonationPass = true
            
            // 대사가 이미 별 3개를 달성한 상태가 아니라면
            if !quote.isCompleted {
                // 별 3개 달성 표시 및 캐릭터의 completedQuotes 증가
                quote.isCompleted = true
                quote.character?.completedQuotes += 1
            }
        }
        
        print("발음 정확도: \(String(format: "%.1f", quote.evaluation.pronunciationScore))%")
        //TODO: 억양 정확도 print("억양 정확도: " )
        print("속도 정확도: \(String(format: "%.1f", quote.evaluation.speedScore))%")
    }

}
