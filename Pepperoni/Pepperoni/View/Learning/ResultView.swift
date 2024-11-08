//
//  ResultView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI

struct ResultView: View {
    let quote: AnimeQuote
    
    @State private var isScoreAnimated: Bool = false // ScoreBar 애니메이션 완료 여부
    @State private var isStarAnimated: Bool = false // Star 애니메이션 완료 여부
    @State private var showCongratulation: Bool = false // 축하 메시지
    
    @State private var navigateToLearningStart = false
    @State private var navigateToLearning = false
    @Binding var showLearningContent: Bool
    
    let temporaryPronunciationScore: Double
    let temporarySpeedScore: Double
    let temporaryIntonationScore: Double
    
    private var totalScore: Int {
        Int(temporaryPronunciationScore + temporarySpeedScore + temporaryIntonationScore)
    }
    
    private var totalPass: Bool {
        quote.evaluation.pronunciationPass && quote.evaluation.intonationPass && quote.evaluation.speedPass
    }
    
    var body: some View {
        ZStack {
            Color.gray2
                .ignoresSafeArea()
            ScrollView {
                if showCongratulation && totalPass {
                    VStack {
                        Text("Congratulate!")
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundStyle(LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "#EAF6FF"), .blue1]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .padding(.bottom, 24)
                            .padding(.top, 48)
                        YouTubePlayerView(videoID: quote.youtubeID, startTime: quote.youtubeStartTime, endTime: quote.youtubeEndTime)
                            .frame(height: 218)
                            .padding(.bottom, 24)
                    }
                }
                
                ZStack {
                    VStack {
                        RoundedRectangle(cornerRadius: 48)
                            .frame(height: 480)
                            .foregroundStyle(Color(hex: "393939"))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 38)
                        
                        HStack(alignment: .center) {
                            Button(action: {
                                // LearningStart로
                                navigateToLearningStart = true
                            }) {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 126, height: 70)
                                        .cornerRadius(20)
                                        .foregroundStyle(Color(hex: "6B6B6B"))
                                    
                                    Text("다시듣기")
                                        .foregroundStyle(.skyBlue1)
                                        .font(.system(size: 18, weight: .bold))
                                }
                            }
                            .padding(.horizontal)
                            
                            Button(action: {
                                // .learning으로
                                navigateToLearning = true
                            } ) {
                                Image(systemName: "arrow.counterclockwise.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.ppBlue, .blue1, .darkGray)
                                    .font(.system(size: 70))
                            }
                        }
                    }
                    
                    VStack {
                        //MARK: - 별 3개
                        HStack(spacing: -50) {
                            StarView(isPassed: temporaryPronunciationScore >= 80, size: 128.68, rotate: -7)
                            StarView(isPassed: temporaryIntonationScore >= 80, size: 150, rotate: 0)
                                .offset(y: -30)
                            StarView(isPassed: temporarySpeedScore >= 80, size: 126, rotate: 7)
                        }
                        .padding(.top)
                        .padding(.bottom, -30)
                        
                        Text("\(totalScore) 점")
                            .font(.system(size: 40))
                            .bold()
                            .foregroundStyle(Color(hex: "C4FFFF"))
                        
                        //MARK: - 막대바 및 점수
                        HStack(spacing: 12) {
                            ScoreBar(title: "발음", score: temporaryPronunciationScore)
                            ScoreBar(title: "높낮이", score: temporaryIntonationScore)
                            ScoreBar(title: "스피드", score: temporarySpeedScore)
                        }
                        Spacer()
                    }
                }
                .frame(height: 750)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // ScoreBar 애니메이션 후 Star 애니메이션
                    isScoreAnimated = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { // Star 애니메이션 후 Congratulation 표시
                        isStarAnimated = true
                        
                        if totalPass {
                            withAnimation(.easeIn(duration: 0.5)) {
                                showCongratulation = true
                            }
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToLearningStart) {
                LearningStartView(quote: quote, showLearningContent: $showLearningContent)
            }
            .navigationDestination(isPresented: $navigateToLearning) {
                LearningView(quote: quote, showLearningContent: $showLearningContent)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showLearningContent = false
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
}

// MARK: - 커졌다가 빛나기
struct StarView: View {
    
    @State private var filled: Bool = false // 애니메이션용 상태 변수
    @State private var scale: CGFloat = 1.0 // 스케일 효과를 위한 변수
    @State private var glowOpacity: Double = 0.0 // 빛나는 효과를 위한 변수
    
    var isPassed: Bool
    var size: CGFloat
    var rotate: CGFloat
    
    var body: some View {
        Image("EmptyStar")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .overlay(
                Image("FilledStar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .opacity(filled && isPassed ? 1 : 0)
                    .scaleEffect(scale) // 스케일 효과 적용
                    .shadow(color: .yellow.opacity(glowOpacity), radius: 10, x: 0, y: 0) // 빛나는 효과
            )
            .rotationEffect(.degrees(rotate))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // ScoreBar 애니메이션 이후 지연
                    withAnimation(.easeInOut(duration: 0.7)) {
                        filled = true
                        scale = 1.2 // 약간 크게 나타나며
                        glowOpacity = 0.8 // 빛나는 효과도 시작
                    }
                    withAnimation(.easeOut(duration: 0.3).delay(0.7)) { // 작아지며 자연스럽게 끝나는 효과
                        scale = 1.0
                        glowOpacity = 0.0 // 빛나는 효과 제거
                    }
                }
            }
    }
}

struct ScoreBar: View {
    
    @State private var animatedScore: Double = 0 // 애니메이션용 변수 추가
    
    var title: String
    var score: Double
    var highlighted: Bool = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 56, height: 272 * animatedScore / 100)
                    .foregroundStyle(score == 100.0 ? .blue1 : .lightGray2)
                    .padding(.bottom, 4)
                Image(systemName: "star.fill")
                    .foregroundStyle(.pointBlue)
                    .opacity(score == 100 ? 1 : 0)
                    .padding(.bottom, 250)
                Text("\(Int(score))%")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.bottom, 12)
                
            }
            .frame(width: 64, height: 280)
            .padding(.horizontal, 5)
            .onAppear {
                // 애니메이션이 뷰가 나타날 때 발생
                withAnimation(.easeOut(duration: 1.5)) {
                    animatedScore = score
                }
            }
            
            Text(title)
                .foregroundStyle(.white)
                .bold()
                .padding(.top, 5)
        }
    }
}
