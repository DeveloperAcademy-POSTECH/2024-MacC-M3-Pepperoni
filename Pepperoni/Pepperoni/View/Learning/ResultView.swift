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
    
    private var totalPass: Bool{
        quote.evaluation.pronunciationPass && quote.evaluation.intonationPass && quote.evaluation.speedPass
    }
    
    var body: some View {
        ScrollView{
            if showCongratulation && totalPass {
                VStack(spacing: 0){
                    Rectangle()
                        .frame(height: 65)
                        .overlay{
                            Text("Congratulate!")
                                .foregroundStyle(.ppBlue)
                                .bold()
                        }
                    YouTubePlayerView(videoID: quote.youtubeID, startTime: 20, endTime: 25)
                        .frame(height: 218)
                        .padding(.bottom, 30)
                }
            }
            
            Text("\(totalScore) 점")
                .font(.system(size: 40))
                .bold()
            
            ZStack{
                VStack{
                    Spacer()
                    RoundedRectangle(cornerRadius: 48)
                        .frame(height: 511)
                        .padding(.horizontal, 20)
                }
                
                VStack{
                    //MARK: - 별 3개
                    HStack(spacing:-30){
                        Star(isPassed: quote.evaluation.pronunciationPass, size: 112)
                        Star(isPassed: quote.evaluation.intonationPass, size: 127)
                            .offset(y: -30)
                        Star(isPassed: quote.evaluation.speedPass, size: 112)
                    }.padding(.bottom, 18)
                    
                    //MARK: - 막대바 및 점수
                    HStack(spacing:12){
                        ScoreBar(title: "발음", score: quote.evaluation.pronunciationScore)
                        ScoreBar(title: "높낮이", score: quote.evaluation.intonationScore)
                        ScoreBar(title: "스피드", score: quote.evaluation.speedScore)
                    }
                    
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.ppBlue, .blue, .gray)
                        .font(.system(size: 50))
                        .padding(.top, 10)
                    
                }
            }.frame(height: 604)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // ScoreBar 애니메이션 후 Star 애니메이션
                isScoreAnimated = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Star 애니메이션 후 Congratulation 표시
                    isStarAnimated = true
                    
                    if totalPass {
                        withAnimation(.easeIn(duration: 0.5)) {
                            showCongratulation = true
                        }
                    }
                }
            }
        }
    }
}

struct Star: View{
    
    @State private var filled: Bool = false // 애니메이션용 상태 변수
    
    var isPassed: Bool
    var size: CGFloat
    
    var body: some View{
        Image(systemName: "star.fill")
            .resizable()
            .foregroundStyle(isPassed ? .ppBlue : .gray)
            .frame(width: size, height: size)
            .overlay{
                Image(systemName: "star.fill")
                    .resizable()
                    .foregroundStyle(filled ? (isPassed ? .blue : .white) : .clear) // 초기에는 색상이 투명하게 설정
                    .frame(width: size * 0.85, height: size * 0.85)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // ScoreBar 애니메이션 이후 지연
                    withAnimation(.easeIn(duration: 0.5)) {
                        filled = true // 애니메이션이 시작되며 색상이 채워짐
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
            ZStack(alignment:.bottom){
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 80, height: 288)
                    .foregroundStyle(.gray)
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 80, height: 288 * animatedScore / 100)
                    .foregroundStyle(score == 100.0 ? .blue : .ppBlue)
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

#Preview {
    ResultView(quote: AnimeQuote(japanese: ["才能は", "開花させる", "もの", "センスは", "磨く", "もの"], pronunciation: ["사이노우와", "카이카사세루", "모노", "센스와", "미가쿠", "모노"], korean: ["재능은", "발휘하는", "것", "센스는", "연마하는", "것"], evaluation: Evaluation(pronunciationScore: 78.0, pronunciationPass: true, intonationScore: 93, intonationPass: true, speedScore: 95.0, speedPass: true), timemark: [2.0, 2.5, 3.3, 5.0, 5.4, 6.0], voicingTime: 0.0, audiofile: "HIQ001.m4a", youtubeID: "", youtubeStartTime: 0, youtubeEndTime: 10))
}
