//
//  AnimeDetailView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI

struct CharacterListView: View {
    let anime: Anime
    
    var dummieAnime: Anime = Anime(
        title: "원피스",
        characters: [
            Character(
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
                    )
                ],
                completedQuotes: 2
            ),
            Character(
                name: "토니토니 초파",
                favorite: true,
                quotes: [
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
                    )
                ],
                completedQuotes: 3
            ),
            Character(
                name: "롤로노아 조로",
                favorite: false,
                quotes: [
                    AnimeQuote(
                        japanese: ["あんたの", "推しの子に", "なって", "やる"],
                        pronunciation: ["안타노", "오시노코니", "낫떼", "야루"],
                        korean: ["너의", "최애의 아이가", "되어", "줄게"],
                        evaluation: Evaluation(pronunciationScore: 100, pronunciationPass: true, intonationScore: 100, intonationPass: true, speedScore: 100, speedPass: true),
                        timemark: [0.1, 1.0, 2.0, 2.5],
                        audiofile: "BST001.m4a"
                    )
                ],
                completedQuotes: 1
            ),
            Character(
                name: "니코 로빈",
                favorite: false,
                quotes: [
                    AnimeQuote(
                        japanese: ["少し", "乱暴", "しようか"],
                        pronunciation: ["스코시", "란보우", "시요우카"],
                        korean: ["조금", "난폭", "해볼까?"],
                        evaluation: Evaluation(pronunciationScore: 100, pronunciationPass: true, intonationScore: 100, intonationPass: true, speedScore: 100, speedPass: true),
                        timemark: [0.1, 1.4, 2.2],
                        audiofile: "JUS001.m4a"
                    )
                ],
                completedQuotes: 0
            ),
            Character(
                name: "상디",
                favorite: false,
                quotes: [
                    AnimeQuote(
                        japanese: ["少し", "乱暴", "しようか"],
                        pronunciation: ["스코시", "란보우", "시요우카"],
                        korean: ["조금", "난폭", "해볼까?"],
                        evaluation: Evaluation(pronunciationScore: 100, pronunciationPass: true, intonationScore: 100, intonationPass: true, speedScore: 100, speedPass: true),
                        timemark: [0.1, 1.4, 2.2],
                        audiofile: "JUS001.m4a"
                    )
                ],
                completedQuotes: 1
            )
        ]
    )

    var body: some View {
        VStack {
            VStack{
                HStack{
                    Spacer()
                    
                    Text(Image(systemName: "pin.square.fill"))
                        .foregroundStyle(.white)
                        .font(.title2)
                }
                
                HStack{
                    Text(dummieAnime.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding()
                    
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.gray)
            
            // -MARK: 캐릭터 리스트
            List(dummieAnime.characters, id: \.id) { character in
                Button {
                    Router.shared.navigate(to: .characterDetail(character: character))
                } label: {
                    GeometryReader { geometry in
                        let totalQuotes = character.quotes.count
                        let completedQuotes = character.completedQuotes
                        let ratio = totalQuotes > 0 ? CGFloat(completedQuotes) / CGFloat(totalQuotes) : 0
                        
                        CharacterRow(character: character, ratio: ratio)
                    }
                }
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
                .frame(height: 68)
                .padding(-2)
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)

            Spacer()
        }
        .navigationTitle(anime.title)
    }
}

// -MARK: Character Row
struct CharacterRow: View {
    var character: Character
    var ratio: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray)
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * ratio, height: 68)
                    .cornerRadius(20)
                    .padding(.bottom, 0)
                
                HStack {
                    Circle()
                        .frame(width: 40, height: 40)
                    
                    Text(character.name)
                    
                    Spacer()
                    
                    Text("\(character.completedQuotes) / \(character.quotes.count)")
                }
                .padding()
                .overlay(
                    character.favorite ?
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.ppBlue)
                        .shadow(color: .black, radius: 0)
                        .font(.title3)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .offset(x: -10, y: 0) : nil,
                    alignment: .topLeading
                )
            }
            .frame(height: 68)
            .cornerRadius(20)
        }
    }
}

#Preview {
    CharacterListView(anime: Anime(title: "hihi"))
}
