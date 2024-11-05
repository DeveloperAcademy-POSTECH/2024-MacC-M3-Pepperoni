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
    
    private var totalScore: Int {
        Int(quote.evaluation.pronunciationScore + quote.evaluation.intonationScore + quote.evaluation.speedScore)
    }
    
    private var totalPass: Bool {
        quote.evaluation.pronunciationPass && quote.evaluation.intonationPass && quote.evaluation.speedPass
    }
    
    var body: some View {
        ScrollView {
            if showCongratulation && totalPass {
                VStack(spacing: 0){
                    Rectangle()
                        .frame(height: 65)
                        .overlay{
                            Text("Congratulate!")
                                .foregroundStyle(.ppBlue)
                                .bold()
                        }
                    YouTubePlayerView(videoID: quote.youtubeID, startTime: quote.youtubeStartTime, endTime: quote.youtubeEndTime)
                        .frame(height: 218)
                        .padding(.bottom, 30)
                }
            }
            
            Text("\(totalScore) 점")
                .font(.system(size: 40))
                .bold()
            
            ZStack {
                VStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 48)
                        .frame(height: 511)
                        .foregroundStyle(.gray1)
                        .padding(.horizontal, 20)
                }
                
                VStack {
                    //MARK: - 별 3개
                    HStack(spacing: -30) {
                        StarView(isPassed: quote.evaluation.pronunciationPass, size: 128.68)
                        StarView(isPassed: quote.evaluation.intonationPass, size: 145.0)
                            .offset(y: -30)
                        StarView(isPassed: quote.evaluation.speedPass, size: 128.68)
                    }.padding(.bottom, 18)
                    
                    //MARK: - 막대바 및 점수
                    HStack(spacing: 12) {
                        ScoreBar(title: "발음", score: quote.evaluation.pronunciationScore)
                        ScoreBar(title: "높낮이", score: quote.evaluation.intonationScore)
                        ScoreBar(title: "스피드", score: quote.evaluation.speedScore)
                    }
                    
                    //TODO: Router에 하나씩 뷰를 쌓아주는 방식은 비효율적인 방식으로 보임, Router 혹은 방식 개선 필요
                    HStack(alignment: .center) {
                        Button(action: {
                            // .learningStart로
                            Router.shared.navPath = NavigationPath()
                            Router.shared.navigate(to: .characterDetail(character: quote.character!))
                            Router.shared.navigate(to: .learningStart(quote: quote))
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 126, height: 65)
                                    .cornerRadius(50)
                                    .foregroundStyle(.gray2)
                                
                                Text("다시듣기")
                                    .foregroundStyle(.blue1)
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        
                        Button(action: {
                            // .learning으로
                            Router.shared.navPath = NavigationPath()
                            Router.shared.navigate(to: .characterDetail(character: quote.character!))
                            Router.shared.navigate(to: .learningStart(quote: quote))
                            Router.shared.navigate(to: .learning(quote: quote))
                        } ) {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.ppBlue, .blue, .gray2)
                                .font(.system(size: 65))
                        }
                    }
                    
                }
            }
            .frame(height: 604)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Router.shared.navigateToRoot()
                }) {
                    Image(systemName: "xmark")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.gray1)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview{
    ResultView(quote: AnimeQuote(
        japanese: ["このまま", "バンドを", "終わらせ", "たく", "ない"],
        pronunciation: ["코노마마", "반도오", "오와라세", "타쿠", "나이"],
        korean: ["이대로", "밴드를", "끝내고", "싶지", "않아!"],
        evaluation: Evaluation(
            pronunciationScore: 85.0,
            pronunciationPass: true,
            intonationScore: 90.0,
            intonationPass: true,
            speedScore: 80.0,
            speedPass: true),
        timemark: [0.2, 1.4, 1.7, 2.3, 2.6],
        voicingTime: 2.7,
        audiofile: "BTR005.m4a",
        character: nil, // 특정 캐릭터 객체를 설정하려면 Character 인스턴스를 여기 추가
        isCompleted: true,
        youtubeID: "6gQGHGpoBm4",
        youtubeStartTime: 120,
        youtubeEndTime: 140
    ))
}

// MARK: - 민무늬 스타뷰
// 추가적인 애니메이션 배제할 시에는 해당 코드로 다시 진행함.
//struct StarView: View {
//    
//    @State private var filled: Bool = false // 애니메이션용 상태 변수
//    
//    var isPassed: Bool
//    var size: CGFloat
//    
//    var body: some View {
//        Image("Star.empty")
//            .resizable()
//            .scaledToFit()
//            .frame(width: size, height: size)
//            .overlay(
//                Image("Star.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: size, height: size)
//                    .opacity(filled && isPassed ? 1 : 0) // 초기에는 투명, 이후 애니메이션으로 채워짐
//            )
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // ScoreBar 애니메이션 이후 지연
//                    withAnimation(.easeIn(duration: 0.5)) {
//                        filled = true // 애니메이션이 시작되며 Star.fill이 채워짐
//                    }
//                }
//            }
//    }
//}

// MARK: - 커졌다가 빛나기
struct StarView: View {
    
    @State private var filled: Bool = false // 애니메이션용 상태 변수
    @State private var scale: CGFloat = 1.0 // 스케일 효과를 위한 변수
    @State private var glowOpacity: Double = 0.0 // 빛나는 효과를 위한 변수
    
    var isPassed: Bool
    var size: CGFloat
    
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
        VStack{
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 80, height: 288)
                    .foregroundStyle(.lightGray2)
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 80, height: 288 * animatedScore / 100)
                    .foregroundStyle(score == 100.0 ? .blue : .skyBlue1)
                Text("\(Int(score))%")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.bottom, 19)
            }
            .onAppear {
                // 애니메이션이 뷰가 나타날 때 발생
                withAnimation(.easeOut(duration: 1.5)) {
                    animatedScore = score
                }
            }
            Text(title)
                .foregroundStyle(.white)
                .bold()
                .padding(.top, 10)
        }
    }
}
