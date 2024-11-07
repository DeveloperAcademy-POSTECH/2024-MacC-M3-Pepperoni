//
//  LearningStartView.swift
//  Pepperoni
//
//  Created by 변준섭 on 10/30/24.
//

import SwiftUI

struct LearningStartView: View {
    let quote: AnimeQuote
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    
    @State private var currentPage = 0  // 현재 페이지를 관리할 변수
    @State var beforeFirstPlaying: Bool = true
    
    @State private var navigateToLearning = false
    @Binding var showLearningContent: Bool
    
    var body: some View {
        ZStack {
            Color.lsBgBlack
                .ignoresSafeArea()
            VStack {
                SpeechBubble()
                    .fill(Color.skyBlue1)
                    .frame(height: 340)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .overlay{
                        VStack {
                            if quote.pronunciation.count >= 5 {
                                let halfIndex = quote.pronunciation.count / 2
                                                                
                                // 페이지 내용
                                VStack {
                                    if currentPage == 0 {
                                        VStack {
                                            highlightedText(textArray: Array(quote.pronunciation.prefix(halfIndex)), indexOffset: 0, isPronunciation: true)
                                            highlightedText(textArray: Array(quote.japanese.prefix(halfIndex)), indexOffset: 0)
                                                .padding(.vertical, 35)
                                            highlightedText(textArray: Array(quote.korean.prefix(halfIndex)), indexOffset: 0)
                                        }
                                    } else {
                                        VStack {
                                            highlightedText(textArray: Array(quote.pronunciation.suffix(from: halfIndex)), indexOffset: halfIndex, isPronunciation: true)
                                            highlightedText(textArray: Array(quote.japanese.suffix(from: halfIndex)), indexOffset: halfIndex)
                                                .padding(.vertical, 35)
                                            highlightedText(textArray: Array(quote.korean.suffix(from: halfIndex)), indexOffset: halfIndex)
                                            
                                        }
                                    }
                                    
                                    // 페이지 내용
                                    VStack {
                                        if currentPage == 0 {
                                            VStack {
                                                highlightedText(textArray: Array(quote.korean.prefix(halfIndex)), indexOffset: 0)
                                                highlightedText(textArray: Array(quote.japanese.prefix(halfIndex)), indexOffset: 0)
                                                    .padding(.vertical, 35)
                                                highlightedText(textArray: Array(quote.pronunciation.prefix(halfIndex)), indexOffset: 0, isPronunciation: true)
                                            }
                                        } else {
                                            VStack {
                                                highlightedText(textArray: Array(quote.korean.suffix(from: halfIndex)), indexOffset: halfIndex)
                                                highlightedText(textArray: Array(quote.japanese.suffix(from: halfIndex)), indexOffset: halfIndex)
                                                    .padding(.vertical, 35)
                                                highlightedText(textArray: Array(quote.pronunciation.suffix(from: halfIndex)), indexOffset: halfIndex, isPronunciation: true)
                                            }
                                        }, label:{
                                            Circle()
                                                .fill(currentPage == 0 ? .lightGray1 : .lsButtonLightBlue)
                                                .frame(width: 35, height: 35)
                                                .overlay {
                                                    Image(systemName: "play.fill")
                                                        .foregroundStyle(currentPage == 0 ? .lightGray2 : .blue1)
                                                        .frame(width: 23)
                                                        .rotationEffect(.degrees(180))
                                                }
                                        })
                                        .disabled(currentPage == 0)  // 첫 페이지에서는 비활성화
                                        
                                        // 페이지 인디케이터
                                        Text("\(currentPage + 1) / 2")
                                            .font(.system(size: 26))
                                            .bold()
                                            .foregroundStyle(.white)
                                            .background{
                                                RoundedRectangle(cornerRadius: 80)
                                                    .frame(width:78, height: 40)
                                                    .foregroundStyle(.lsButtonLightBlue)
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
                                        }, label:{
                                            Circle()
                                                .fill(currentPage == 1 ? .lightGray1 : .lsButtonLightBlue)
                                                .frame(width: 35, height: 35)
                                                .overlay {
                                                    Image(systemName: "play.fill")
                                                        .foregroundStyle(currentPage == 1 ? .lightGray2 : .blue1)
                                                        .frame(width: 23)
                                                }
                                        })
                                        .disabled(currentPage == 1)  // 마지막 페이지에서는 비활성화
                                    }
                                    .frame(height: 340)
                                    .padding(.horizontal, 20)
                                } else {
                                    // pronunciation 배열의 길이가 5 미만일 때 기존 방식으로 한 페이지에 표시
                                    VStack {
                                        highlightedText(textArray: quote.korean, indexOffset: 0)
                                        highlightedText(textArray: quote.japanese, indexOffset: 0)
                                            .padding(.vertical, 35)
                                        highlightedText(textArray: quote.pronunciation, indexOffset: 0, isPronunciation: true)
                                    }
                                    .frame(height: 300)
                                    .padding(.horizontal, 20)
                                }
                                .frame(height: 340)
                                .padding(.horizontal, 20)
                            } else {
                                // pronunciation 배열의 길이가 5 미만일 때 기존 방식으로 한 페이지에 표시
                                VStack {
                                    highlightedText(textArray: quote.pronunciation, indexOffset: 0, isPronunciation: true)
                                    highlightedText(textArray: quote.japanese, indexOffset: 0)
                                        .padding(.vertical, 35)
                                    highlightedText(textArray: quote.korean, indexOffset: 0)
                                    
                                }
                                .frame(height: 300)
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                
                Button(action: {
                    audioPlayerManager.playAudio(from: quote.audiofile)
                    beforeFirstPlaying = false
                }, label:{
                    Image("Roni")
                        .resizable()
                        .scaledToFit()
                        .frame(width:103)
                        .padding(.bottom, 20)
                })
                
                HStack {
                    Image(systemName: "speaker.wave.2")
                    Text("캐릭터를 눌러 명대사를 들어보세요")
                        .bold()
                }
                .foregroundStyle(.lsSoundGray)
                .padding(.bottom, 57)
                
                Button(action:{
                    Router.shared.navigate(to: .learning(quote: quote))
                }, label:{
                    RoundedRectangle(cornerRadius: 6)
                        .fill(beforeFirstPlaying || audioPlayerManager.isPlaying ? Color.lightGray2 : Color.pointBlue)
                        .strokeBorder(beforeFirstPlaying || audioPlayerManager.isPlaying ? Color.lightGray2 : Color.innerStrokeBlue, lineWidth: 3)
                        .frame(height:60)
                        
                        .padding(.horizontal, 20)
                        .overlay{
                            HStack {
                                Text("명대사 말하기")
                                    .bold()
                                Image(systemName: "play.fill")
                            }
                            .foregroundStyle(beforeFirstPlaying || audioPlayerManager.isPlaying ? .lightGray1 : .white)
                            .opacity(beforeFirstPlaying || audioPlayerManager.isPlaying ? 0.3 : 1)
                            .font(.system(size: 20))
                        }
                })
                .disabled(beforeFirstPlaying || audioPlayerManager.isPlaying)
            }
        }
    }
    
    private func updatePageBasedOnCurrentTime(currentTime: Double, halfIndex: Int) {
        let halfTime = quote.timemark[halfIndex]
        if currentTime >= halfTime && currentPage == 0 {
            currentPage = 1
        } else if currentTime < halfTime && currentPage == 1 {
            currentPage = 0
        }
    }
    
    private func highlightedText(textArray: [String], indexOffset: Int, isPronunciation: Bool = false) -> some View {
        HStack {
            ForEach(textArray.indices, id: \.self) { index in
                Text(textArray[index])
                    .font(isPronunciation ? .system(size: 20, weight: .bold) : .system(size: 26, weight: .bold))
                    .foregroundStyle(
                        isPlayingWord(at: index + indexOffset)
                        ? .pointBlue // 재생 중이면 pointBlue 강조
                        : (isPronunciation
                            ? .black // 발음일 경우 검은색
                            : (textArray == quote.korean
                                ? .gray // 한국어일 경우 회색
                                : .black) // 그 외의 경우 검은색
                        )
                    )
            }
        }
    }

    
    // 현재 재생 중인 단어인지 확인하는 함수 추가
    private func isPlayingWord(at index: Int) -> Bool {
        guard index < quote.timemark.count else { return false }
        
        // `audioPlayerManager.currentTime`을 사용하여 현재 재생 시간을 가져옵니다.
        let startTime = quote.timemark[index]
        let currentTime = audioPlayerManager.currentTime
        
        // 마지막 인덱스일 때는 `startTime`만 비교
        if index == quote.timemark.count - 1 {
            return currentTime >= startTime
        }
        
        // 마지막 인덱스가 아닐 때는 `startTime`과 `endTime` 사이에 있는지 확인
        let endTime = quote.timemark[index + 1]
        return currentTime >= startTime && currentTime < endTime
    }
    
}

struct SpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 말풍선 본체
        path.addRoundedRect(in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height * 0.93), cornerSize: CGSize(width: 26, height: 26))
        
        // 꼬리 부분
        let tailWidth: CGFloat = 34
        let tailHeight: CGFloat = 35
        let tailXOffset = (rect.width - tailWidth) / 2 // 꼬리 중심 정렬
        let tailYOffset = rect.height * 0.93 // 말풍선 본체와 겹치는 지점
        
        path.move(to: CGPoint(x: tailXOffset, y: tailYOffset))
        path.addLine(to: CGPoint(x: tailXOffset + tailWidth, y: tailYOffset))
        path.addLine(to: CGPoint(x: rect.midX, y: tailYOffset + tailHeight))
        path.closeSubpath()
                
        return path
    }
}
