//
//  CharacterDetailView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI
import AVFoundation
import SwiftData

struct CharacterDetailView: View {
    let character: Character
    
    @State private var selectedIndex: Int? = 0
    
    let itemHeight: CGFloat = 58.0
    let menuHeightMultiplier: CGFloat = 5
    
    @Query(filter: #Predicate<Character> { $0.favorite == true })
    private var favoriteCharacters: [Character]
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .foregroundStyle(.gray1)
                    .frame(height: 584)
                    .cornerRadius(60)
                
                // -MARK: 하트 버튼
                VStack{
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            toggleFavorite()
                        }) {
                                Image(systemName: character.favorite ? "heart.fill" : "heart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 26, height: 25)
                                    .foregroundColor(character.favorite ? .blue1 : .white)
                        }
                    }
                    .padding(.top, 8)
                    
                    ZStack {
                        Rectangle()
                            .foregroundStyle(.darkGray)
                            .frame(width: 134, height: 134)
                            .border(.white, width: 3)
                        
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 82, height: 87)
                            .foregroundStyle(.blueWhite)
                        
                        
                        // 사진 추가 버튼 !!! 준요 여기야 
                        Button {
                        
                        } label: {
                            ZStack{
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.lightGray1)
                                
                                Image(systemName: "plus")
                                    .foregroundStyle(.darkGray)
                            }
                        }
                        .offset(x: 60, y: 56)
                    }
                    .padding(.bottom, 4)
                    
                    Text("\(character.name)")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    
                    VStack(alignment: .leading) {
                        HStack{
                            Text("총점수")
                                .padding(.bottom, 2)
                                .foregroundStyle(.gray1)
                            
                            Spacer()
                            
                            Rectangle()
                                .frame(width: 151, height: 1)
                                .foregroundStyle(.lightGray2)
                            
                            Spacer()
                            
                            Text("\(calculateScoresAndPasses(for: character).totalScore)")
                                .padding(.bottom, 2)
                                .fontWeight(.medium)
                                .foregroundStyle(.pointBlue)
                        }
                        
                        HStack{
                            Text("별")
                                .padding(.bottom, 2)
                                .foregroundStyle(.gray1)
                            
                            Spacer()
                            
                            Rectangle()
                                .frame(width: 151, height: 1)
                                .foregroundStyle(.lightGray2)
                            
                            Spacer()
                            
                            Text("\(calculateScoresAndPasses(for: character).totalPasses)")
                                .padding(.bottom, 2)
                                .fontWeight(.medium)
                                .foregroundStyle(.pointBlue)
                        }
                        
                        HStack {
                            Text("달성률")
                            
                            Spacer()
                            
                            // 달성률을 나타내는 바
                            GeometryReader { geometry in
                                let totalQuotes = character.quotes.count
                                let completedQuotes = character.completedQuotes
                                let ratio = totalQuotes > 0 ? CGFloat(completedQuotes) / CGFloat(totalQuotes) : 0
                                
                                AchievementBar(ratio: ratio)
                            }
                            .frame(width: 188, height: 20)
                            
                            Spacer()
                            
                            Text("\(character.completedQuotes)/\(character.quotes.count)")
                                .fontWeight(.medium)
                                .foregroundStyle(.pointBlue)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                    
                    Spacer()
                    
                    // -MARK: 대사 리스트
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                            Spacer().frame(height: itemHeight * 2.5) // 스크롤 여유 공간
                            
                            ForEach(0..<character.quotes.count, id: \.self) { index in
                                let quote = character.quotes[index]
                                
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
                                        .fill(index == selectedIndex ? Color.pointBlue : Color.blue1)
                                )
                                .id(index)
                                .frame(height: itemHeight)
                                .padding(.vertical, index == selectedIndex ? 24 : 16)
                                .onTapGesture {
                                    Router.shared.navigate(to: .learningStart(quote: character.quotes[index]))
                                    AVAudioApplication.requestRecordPermission { granted in
                                        if granted {
                                            print("마이크 접근 권한이 허용되었습니다.")
                                        } else {
                                            print("마이크 접근 권한이 거부되었습니다.")
                                        }
                                    }
                                }
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
        .background(.darkGray)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("최애 자리가 다 찼어요"), message: Text("최애 캐릭터는 3개까지 설정 가능해요🥹"), dismissButton: .default(Text("확인")))
        }
    }
    
    /// 별, 총점수 계산 함수
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
    
    /// 최애(favorite) 설정 함수
    private func toggleFavorite() {
        if favoriteCharacters.count < 3 || character.favorite {
            character.favorite.toggle()
        } else {
            showAlert = true
        }
    }
}

struct AchievementBar: View {
    var ratio: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.darkGray)
                
                Rectangle()
                    .fill(Color.blue1)
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

