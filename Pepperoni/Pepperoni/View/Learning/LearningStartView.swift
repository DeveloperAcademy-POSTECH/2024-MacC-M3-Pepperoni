//
//  LearningStartView.swift
//  Pepperoni
//
//  Created by 변준섭 on 10/30/24.
//

import SwiftUI

struct LearningStartView: View {
    
    let quote: AnimeQuote
    
    @State private var currentPage = 0  // 현재 페이지를 관리할 변수
    
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    
    @State var afterFirstPlaying: Bool = true
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            VStack {
                SpeechBubble()
                    .fill(Color.skyBlue1)
                    .frame(height: 340)
                    .padding(.horizontal, 20)
                    .overlay{
                        VStack {
                            if quote.pronunciation.count >= 5 {
                                let halfIndex = quote.pronunciation.count / 2
                                                                
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
                        }
                    }
                
                Image("Roni")
                    .resizable()
                    .scaledToFit()
                    .frame(width:103)
                    .padding()
                
                Button(action:{
                    // 오디오파일 재생이 들어감
                    audioPlayerManager.playAudio(from: quote.audiofile)
                    afterFirstPlaying = false
                }, label:{
                    RoundedRectangle(cornerRadius: 6)
                        .frame(height:50)
                        .padding(.horizontal, 20)
                        .foregroundStyle(.blue1)
                        .overlay{
                            HStack{
                                Text("명대사 듣기")
                                Image(systemName: "speaker.wave.2")
                            }
                            .foregroundStyle(.white)
                        }
                })
                .disabled(audioPlayerManager.isPlaying)
                
                Button(action:{
                    Router.shared.navigate(to: .learning(quote: quote))
                }, label:{
                    RoundedRectangle(cornerRadius: 6)
                        .frame(height:60)
                        .foregroundStyle(afterFirstPlaying || audioPlayerManager.isPlaying ? .gray1 : .white)
                        .padding(.horizontal, 20)
                        .overlay{
                            Text("명대사 따라하기 시작")
                                .bold()
                                .foregroundStyle(afterFirstPlaying || audioPlayerManager.isPlaying ? .white : .blue1)
                                .opacity(afterFirstPlaying || audioPlayerManager.isPlaying ? 0.3 : 1)
                                .font(.system(size: 20))
                        }
                })
                .disabled(afterFirstPlaying || audioPlayerManager.isPlaying)
            }
        }
        .onReceive(audioPlayerManager.$currentTime) { currentTime in
            let halfIndex = quote.pronunciation.count / 2
            updatePageBasedOnCurrentTime(currentTime: currentTime, halfIndex: halfIndex)
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
                    .foregroundColor(isPlayingWord(at: index + indexOffset) ? .pointBlue : .black) // 재생 중이면 빨간색으로 강조 표시
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
        path.addRoundedRect(in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height * 0.93), cornerSize: CGSize(width: 16, height: 16))
        
        // 꼬리 부분
        path.move(to: CGPoint(x: rect.width * 0.45, y: rect.height * 0.93))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width * 0.55, y: rect.height * 0.93))
        path.closeSubpath()
        
        return path
    }
}
