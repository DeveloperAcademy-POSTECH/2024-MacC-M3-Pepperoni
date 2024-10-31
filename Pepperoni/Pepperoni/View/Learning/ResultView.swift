//
//  ResultView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI

struct ResultView: View {
    let quote: AnimeQuote
    
    var dummieQuote: AnimeQuote = AnimeQuote(japanese: ["才能は", "開花させる", "もの", "センスは", "磨く", "もの"], pronunciation: ["사이노우와", "카이카사세루", "모노", "센스와", "미가쿠", "모노"], korean: ["재능은", "발휘하는", "것", "센스는", "연마하는", "것"], evaluation: Evaluation(pronunciationScore: 78.0, pronunciationPass: false, intonationScore: 93, intonationPass: false, speedScore: 95.0, speedPass: false), timemark: [2.0, 2.5, 3.3, 5.0, 5.4, 6.0], audiofile: "HIQ001.m4a")
    
    var body: some View {
        ZStack {
             Color.gray
                 .ignoresSafeArea()
             VStack {
                 HStack {
                     Spacer()
                     Button(action: {
                         // 닫기 액션
                     }) {
                         Image(systemName: "xmark")
                             .foregroundColor(.white)
                             .font(.system(size: 24))
                     }
                 }
                 .padding()
                 
                 Spacer()
                 
                 VStack(spacing: 20) {
                     HStack(spacing: 10) {
                         // 별 3개
                         ForEach(0..<3) { index in
                             Image(systemName: index == 1 ? "star" : "star.fill")
                                 .resizable()
                                 .frame(width:100, height:100)
                                 .foregroundColor(index == 1 ? Color.blue : Color.white)
                         }
                     }
                     
                     HStack(spacing: 30) {
                         // 발음, 높낮이, 스피드의 퍼센트 바
                         ScoreBar(title: "발음", score: 30)
                         ScoreBar(title: "높낮이", score: 120, highlighted: true)
                         ScoreBar(title: "스피드", score: 50)
                     }
                     
                     Text("3888점")
                         .font(.largeTitle)
                         .bold()
                         .foregroundColor(Color.blue)
                     
                     Button(action: {
                         // 재시도 액션
                     }) {
                         Image(systemName: "arrow.counterclockwise.circle.fill")
                             .font(.system(size: 40))
                             .foregroundColor(Color.gray)
                     }
                 }
                 .padding()
                 .background(Color.blue.opacity(0.2))
                 .cornerRadius(20)
                 .padding(.horizontal, 40)
                 
                 Spacer()
             }
         }
    }
}

struct ScoreBar: View {
    var title: String
    var score: Int
    var highlighted: Bool = false
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(highlighted ? Color.blue : Color.gray, lineWidth: 2)
                .frame(width: 50, height: 150)
                .overlay(
                    Text("\(score)%")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.bottom, 5),
                    alignment: .bottom
                )
            
            Text(title)
                .font(.caption)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    ResultView(quote: AnimeQuote(japanese: ["才能は", "開花させる", "もの", "センスは", "磨く", "もの"], pronunciation: ["사이노우와", "카이카사세루", "모노", "센스와", "미가쿠", "모노"], korean: ["재능은", "발휘하는", "것", "센스는", "연마하는", "것"], evaluation: Evaluation(pronunciationScore: 78.0, pronunciationPass: false, intonationScore: 93, intonationPass: false, speedScore: 95.0, speedPass: false), timemark: [2.0, 2.5, 3.3, 5.0, 5.4, 6.0], audiofile: "HIQ001.m4a"))
}
