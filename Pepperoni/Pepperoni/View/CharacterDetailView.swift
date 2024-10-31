//
//  CharacterDetailView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    
    var dummieCharacter: Character = Character(
        name: "몽키 디 루피",
        favorite: true,
        quotes: [
            AnimeQuote(
                japanese: ["才能は", "開花させる", "もの", "センスは", "磨く", "もの"],
                pronunciation: ["사이노우와", "카이카사세루", "모노", "센스와", "미가쿠", "모노"],
                korean: ["재능은", "발휘하는", "것", "센스는", "연마하는", "것"],
                evaluation: Evaluation(pronunciationScore: 100, pronunciationPass: true, intonationScore: 100, intonationPass: true, speedScore: 100, speedPass: true),
                timemark: [2.0, 2.5, 3.3, 5.0, 5.4, 6.0],
                audiofile: "HIQ001.m4a"
            ),
            AnimeQuote(
                japanese: ["長い間", "くそ", "お世話に", "なりました"],
                pronunciation: ["나가이아이다", "쿠소", "오세와니", "나리마시타"],
                korean: ["오랜시간", "빌어먹게", "신세를", "졌습니다"],
                evaluation: Evaluation(pronunciationScore: 100, pronunciationPass: true, intonationScore: 100, intonationPass: true, speedScore: 100, speedPass: true),
                timemark: [1.9, 3.0, 3.9, 4.6],
                audiofile: "ONP001.m4a"
            ),
            AnimeQuote(
                japanese: ["長い間", "くそ", "お世話に", "なりました"],
                pronunciation: ["나가이아이다", "쿠소", "오세와니", "나리마시타"],
                korean: ["오랜시간", "빌어먹게", "신세를", "졌습니다"],
                evaluation: Evaluation(pronunciationScore: 100, pronunciationPass: true, intonationScore: 100, intonationPass: true, speedScore: 100, speedPass: true),
                timemark: [1.9, 3.0, 3.9, 4.6],
                audiofile: "ONP001.m4a"
            ),
            AnimeQuote(
                japanese: ["長い間", "くそ", "お世話に", "なりました"],
                pronunciation: ["나가이아이다", "쿠소", "오세와니", "나리마시타"],
                korean: ["오랜시간", "빌어먹게", "신세를", "졌습니다"],
                evaluation: Evaluation(pronunciationScore: 100, pronunciationPass: true, intonationScore: 100, intonationPass: true, speedScore: 100, speedPass: true),
                timemark: [1.9, 3.0, 3.9, 4.6],
                audiofile: "ONP001.m4a"
            ),
            AnimeQuote(
                japanese: ["長い間", "くそ", "お世話に", "なりました"],
                pronunciation: ["나가이아이다", "쿠소", "오세와니", "나리마시타"],
                korean: ["오랜시간", "빌어먹게", "신세를", "졌습니다"],
                evaluation: Evaluation(pronunciationScore: 100, pronunciationPass: true, intonationScore: 100, intonationPass: true, speedScore: 100, speedPass: true),
                timemark: [1.9, 3.0, 3.9, 4.6],
                audiofile: "ONP001.m4a"
            ),
            AnimeQuote(
                japanese: ["長い間", "くそ", "お世話に", "なりました"],
                pronunciation: ["나가이아이다", "쿠소", "오세와니", "나리마시타"],
                korean: ["오랜시간", "빌어먹게", "신세를", "졌습니다"],
                evaluation: Evaluation(pronunciationScore: 100, pronunciationPass: true, intonationScore: 100, intonationPass: true, speedScore: 100, speedPass: true),
                timemark: [1.9, 3.0, 3.9, 4.6],
                audiofile: "ONP001.m4a"
            ),
            AnimeQuote(
                japanese: ["長い間", "くそ", "お世話に"],
                pronunciation: ["나가이아이다", "쿠소", "오세와니"],
                korean: ["내가", "해적왕이", "될테야!"],
                evaluation: Evaluation(pronunciationScore: 100, pronunciationPass: true, intonationScore: 100, intonationPass: true, speedScore: 100, speedPass: true),
                timemark: [1.9, 3.0, 3.9],
                audiofile: "ONP001.m4a"
            )
        ],
        completedQuotes: 2
    )
    
    @State private var selectedIndex: Int? = 0
    
    let itemHeight: CGFloat = 58.0
    let menuHeightMultiplier: CGFloat = 5
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .frame(height: 584)
                    .cornerRadius(60)
                
                VStack{
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            toggleFavorite() // 즐겨찾기 상태 토글
                        }) {
                            Image(systemName: character.favorite ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 26, height: 25)
                                .foregroundColor(character.favorite ? .blue : .white)
                        }
                        .padding(.top)
                    }
                    
                    Rectangle()
                        .frame(width: 134, height: 134)
                        .cornerRadius(16)
                        .border(.white, width: 3)
                    
                    Text("\(dummieCharacter.name)")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    
                    VStack(alignment: .leading) {
                        HStack{
                            Text("총점수")
                                .padding(.bottom, 2)
                            
                            Spacer()
                            
                            Rectangle()
                                .frame(width: 151, height: 1)
                            
                            Spacer()
                            
                            Text("\(calculateScoresAndPasses(for: dummieCharacter).totalScore)")
                                .padding(.bottom, 2)
                                .fontWeight(.medium)
                                .foregroundStyle(.ppBlue)
                        }
                        
                        HStack{
                            Text("별")
                                .padding(.bottom, 2)
                            
                            Spacer()
                            
                            Rectangle()
                                .frame(width: 151, height: 1)
                            
                            Spacer()
                            
                            Text("\(calculateScoresAndPasses(for: dummieCharacter).totalPasses)")
                                .padding(.bottom, 2)
                                .fontWeight(.medium)
                                .foregroundStyle(.ppBlue)
                        }
                        
                        HStack {
                            Text("달성률")
                            
                            Spacer()
                            
                            // 달성률을 나타내는 바
                            GeometryReader { geometry in
                                let totalQuotes = dummieCharacter.quotes.count
                                let completedQuotes = dummieCharacter.completedQuotes
                                let ratio = totalQuotes > 0 ? CGFloat(completedQuotes) / CGFloat(totalQuotes) : 0
                                
                                AchievementBar(ratio: ratio)
                            }
                            .frame(width: 188, height: 20)
                            
                            Spacer()
                            
                            Text("\(dummieCharacter.completedQuotes)/\(dummieCharacter.quotes.count)")
                                .fontWeight(.medium)
                                .foregroundStyle(.ppBlue)
                        }
                    }
                    .padding()
                    .background(Color.white) // 통계 배경색
                    .cornerRadius(10)
                    .padding()
                    
                    Spacer()
                    
                    // -MARK: 대사 리스트
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                            Spacer().frame(height: itemHeight * 2.5) // 스크롤 여유 공간
                            
                            ForEach(0..<dummieCharacter.quotes.count, id: \.self) { index in
                                let quote = dummieCharacter.quotes[index]
                                
                                VStack(alignment: .leading) {
                                    HStack{
                                        Text(quote.korean.joined(separator: " "))
                                            .foregroundStyle(.white)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Spacer()
                                        
                                        Text("#\(index+1)")
                                            .foregroundStyle(.white)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                    }
                                    
                                    // selectedIndex와 일치하는 경우에만 quote.japanese 표시
                                    if index == selectedIndex {
                                        Text(quote.japanese.joined(separator: " "))
                                            .foregroundStyle(.white)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .padding(.top, 4)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(index == selectedIndex ? Color.blue : Color.ppBlue)
                                )
                                .id(index)
                                .frame(height: itemHeight)
                                .padding(.vertical, index == selectedIndex ? 36 : 16)
                            }
                            
                            Spacer().frame(height: itemHeight * 2.5) // 스크롤 여유 공간
                        }
                        .scrollTargetLayout()
                        .padding()
                        
                    }
                    .background(.white)
                    .scrollPosition(id: $selectedIndex, anchor: .center)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                    .frame(height: 391)
                    .cornerRadius(20)
                }
            }
        }
        .padding()
        .background(.gray)
    }
    
    // 별, 총점수 계산 함수
    func calculateScoresAndPasses(for character: Character) -> (totalScore: Int, totalPasses: Int) {
        var totalScore = 0
        var totalPasses = 0
        
        for quote in character.quotes {
            // 점수 총합 계산
            totalScore += Int(quote.evaluation.pronunciationScore)
            totalScore += Int(quote.evaluation.intonationScore)
            totalScore += Int(quote.evaluation.speedScore)
            
            // 패스 횟수 총합 계산
            if quote.evaluation.pronunciationPass { totalPasses += 1 }
            if quote.evaluation.intonationPass { totalPasses += 1 }
            if quote.evaluation.speedPass { totalPasses += 1 }
        }
        
        return (totalScore, totalPasses)
    }
    
    // 즐겨찾기 상태 토글 함수
    private func toggleFavorite() {
        character.favorite.toggle() // favorite 상태를 토글
    }
}

struct AchievementBar: View {
    var ratio: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray)
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * ratio, height: 20)
                    .cornerRadius(20)
                    .padding(.bottom, 0)
            }
            .frame(height: 20)
            .cornerRadius(20)
        }
    }
}


#Preview {
    CharacterDetailView(character: Character(name: "고죠", favorite: false))
}

