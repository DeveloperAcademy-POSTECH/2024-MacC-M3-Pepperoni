//
//  LearningStartView.swift
//  Pepperoni
//
//  Created by 변준섭 on 10/30/24.
//

import SwiftUI

struct LearningStartView: View {
    
    let quote: AnimeQuote
    
    var dummieQuote: AnimeQuote = AnimeQuote(japanese: ["天上天下", "唯我独尊"], pronunciation: ["텐조오텐게", "유이가도쿠손"], korean: ["천상천하", "유아독존"], evaluation: Evaluation(pronunciationScore: 0.0, pronunciationPass: false, intonationScore: 0.0, intonationPass: false, speedScore: 0.0, speedPass: false), timemark: [0.01, 1.6], voicingTime: 0.0, audiofile: "JUJ005.m4a", youtubeID: "cJVeIwP_HoQ", youtubeStartTime: 90, youtubeEndTime: 115)
    
    @State private var currentPage = 0  // 현재 페이지를 관리할 변수
    
    var body: some View {
        ZStack{
            Color.gray
                .ignoresSafeArea()
            VStack {
                SpeechBubble()
                    .fill(Color.blue)
                    .frame(height: 340)
                    .padding(.horizontal, 47.5)
                    .overlay{
                        VStack {
                            // TODO: dummieQuote -> quote로 변경
                            if dummieQuote.pronunciation.count >= 5 {
                                let halfIndex = dummieQuote.pronunciation.count / 2
                                
                                // 페이지 내용
                                VStack {
                                    if currentPage == 0 {
                                        VStack {
                                            Text(dummieQuote.korean.prefix(halfIndex).joined(separator: " "))
                                                
                                            Text(dummieQuote.japanese.prefix(halfIndex).joined(separator: " "))
                                                .padding(.vertical, 35)
                                            Text(dummieQuote.pronunciation.prefix(halfIndex).joined(separator: " "))
                                                .font(.system(size: 20, weight: .bold))
                                        }
                                        .font(.system(size: 26, weight: .bold))
                                    } else {
                                        VStack {
                                            Text(dummieQuote.korean.suffix(from: halfIndex).joined(separator: " "))
                                            Text(dummieQuote.japanese.suffix(from: halfIndex).joined(separator: " "))
                                                .padding(.vertical, 35)
                                            Text(dummieQuote.pronunciation.suffix(from: halfIndex).joined(separator: " "))
                                                .font(.system(size: 20, weight: .bold))
                                        }
                                        .font(.system(size: 26, weight: .bold))
                                    }
                                    
                                    HStack {
                                        // 이전 페이지 버튼
                                        Button(action: {
                                            if currentPage > 0 {
                                                currentPage -= 1
                                            }
                                        }) {
                                            Image(systemName: "arrow.left")
                                                .foregroundColor(currentPage == 0 ? .gray : .white)
                                                .padding()
                                            
                                        }
                                        .disabled(currentPage == 0)  // 첫 페이지에서는 비활성화
                                        
                                        // 페이지 인디케이터
                                        Text("\(currentPage + 1) / 2")
                                            .font(.system(size: 26))
                                            .bold()
                                            .background{
                                                RoundedRectangle(cornerRadius: 15)
                                                    .frame(width:78)
                                                    .foregroundStyle(.white)
                                            }
                                            .padding(.horizontal)
                                        
                                        // 다음 페이지 버튼
                                        Button(action: {
                                            if currentPage < 1 {
                                                currentPage += 1
                                            }
                                        }) {
                                            Image(systemName: "arrow.right")
                                                .foregroundColor(currentPage == 1 ? .gray : .white)
                                                .padding()
                                        }
                                        .disabled(currentPage == 1)  // 마지막 페이지에서는 비활성화
                                    }
                                }
                                .frame(height: 340)
                                .padding(.horizontal, 47.5)
                            } else {
                                // pronunciation 배열의 길이가 5 미만일 때 기존 방식으로 한 페이지에 표시
                                VStack {
                                    Text(dummieQuote.korean.joined(separator: " "))
                                    Text(dummieQuote.japanese.joined(separator: " "))
                                    Text(dummieQuote.pronunciation.joined(separator: " "))
                                }
                                .frame(height: 300)
                                .padding(.horizontal, 47.5)
                            }
                        }
                    }
                
                Image("Roni")
                    .resizable()
                    .scaledToFit()
                    .frame(width:103)
                    .padding()
                
                Button(action:{
                    // 오디오파일 재생이 들어감
                }, label:{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height:50)
                        .padding(.horizontal, 20)
                        .overlay{
                            HStack{
                                Text("명대사 듣기")
                                Image(systemName: "speaker.wave.2")
                            }
                            .foregroundStyle(.white)
                        }
                })
                
                Button(action:{
                    Router.shared.navigate(to: .learning(quote: quote))
                }, label:{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height:60)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .overlay{
                            Text("명대사 따라하기 시작")
                        }
                })
                
            }
        }
        
    }
}

#Preview {
    LearningStartView(quote: AnimeQuote(japanese: ["天上天下", "唯我独尊"], pronunciation: ["텐조오텐게", "유이가도쿠손"], korean: ["천상천하", "유아독존"], evaluation: Evaluation(pronunciationScore: 0.0, pronunciationPass: false, intonationScore: 0.0, intonationPass: false, speedScore: 0.0, speedPass: false), timemark: [0.01, 1.6], voicingTime: 0.0, audiofile: "JUJ005.m4a", youtubeID: "cJVeIwP_HoQ", youtubeStartTime: 90, youtubeEndTime: 115))
}

struct SpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 말풍선 본체
        path.addRoundedRect(in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height * 0.93), cornerSize: CGSize(width: 16, height: 16))
        
        // 꼬리 부분
        path.move(to: CGPoint(x: rect.width * 0.45, y: rect.height * 0.93))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width * 0.55, y: rect.height * 0.93))
        path.closeSubpath()
        
        return path
    }
}
