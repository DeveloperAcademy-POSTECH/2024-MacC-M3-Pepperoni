//
//  CharacterDetailView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI
import SwiftData
import AVFoundation
import SwiftData

struct CharacterDetailView: View {
    let character: Character
    
    @State private var selectedIndex: Int? = 0
    @State private var selectedImage: Data?
    @State private var isCameraPickerPresented = false
    
    let itemHeight: CGFloat = 58.0
    let menuHeightMultiplier: CGFloat = 5
    
    @Query(filter: #Predicate<Character> { $0.favorite == true })
    private var favoriteCharacters: [Character]
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(.gray1)
                    .frame(height: 584)
                    .cornerRadius(60)
                
                VStack {
                    // -MARK: 캐릭터 프로필
                    ZStack {
                        if let selectedImage = character.image, let image = UIImage(data: selectedImage) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 134, height: 134)
                                .clipShape(Rectangle())
                        } else {
                            // 기본 이미지
                            Rectangle()
                                .foregroundStyle(.darkGray)
                                .frame(width: 134, height: 134)
                                .border(.white, width: 3)
                            
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 82, height: 87)
                                .foregroundStyle(.blueWhite)
                        }
                        
                        // 사진 추가 버튼
                        Button {
                            isCameraPickerPresented = true
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
                    
                    // -MARK: 총점수, 별, 달성률
                    VStack(alignment: .leading) {
                        HStack {
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
                        
                        HStack {
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
                    QuoteListView(character: character, selectedIndex: $selectedIndex)
                }
            }
            .sheet(isPresented: $isCameraPickerPresented) {
                ImagePickerView(selectedImageData: $selectedImage,
                           mode: .photoLibrary)
            }
        }
        .padding()
        .background(.darkGray)
        .onChange(of: selectedImage) {
            // 이미지 등록 시, SwiftData에 이미지 저장
            if let newImageData = selectedImage {
                character.updateImage(newImageData)
            }
        }
        // -MARK: NavigationBar
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    toggleFavorite()
                }) {
                    ZStack{
                        Image(systemName: character.favorite ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 25)
                            .foregroundStyle(character.favorite ? .blue1 : .clear)
                        
                        Image(systemName: "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 25)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
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

/// 대사 리스트 뷰
struct QuoteListView: View {
    let character: Character
    @Binding var selectedIndex: Int?
    
    let itemHeight: CGFloat = 58.0
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                Spacer().frame(height: itemHeight * 2.5) // 스크롤 여유 공간
                
                ForEach(0..<character.quotes.count, id: \.self) { index in
                    let quote = character.quotes[index]
                    let evaluation = quote.evaluation
                    let passCount = [evaluation.pronunciationPass, evaluation.intonationPass, evaluation.speedPass].filter { $0 }.count
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("#\(index + 1)")
                                .foregroundStyle(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            // 별
                            HStack(spacing: 4) {
                                ForEach(0..<3) { i in
                                    if i < passCount {
                                        Text(Image(systemName: "star.fill"))
                                            .foregroundStyle(.white)
                                    } else {
                                        Text(Image(systemName: "star"))
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                        }
                        
                        // 한국어
                        Text(quote.korean.joined(separator: " "))
                            .foregroundStyle(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // 일본어 - selectedIndex일 때만
                        if index == selectedIndex {
                            Text(quote.japanese.joined(separator: " "))
                                .foregroundStyle(.white)
                                .font(.title3)
                                .fontWeight(.bold)
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
                    .padding(.vertical, index == selectedIndex ? 28 : 20)
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

#Preview {
    CharacterDetailView(character: Character(name: "고죠", favorite: false))
}
