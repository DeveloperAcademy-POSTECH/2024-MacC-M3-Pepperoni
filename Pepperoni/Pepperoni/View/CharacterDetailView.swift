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
import Speech

struct CharacterDetailView: View {
    let character: Character
    
    @State private var selectedIndex: Int? = 0
    @State private var selectedImage: Data?
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @State private var showLearningContent = false
    
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
                        // 사진 추가 버튼
                        Button {
                            showActionSheet = true
                        } label: {
                            if let selectedImage = character.image, let image = UIImage(data: selectedImage) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 134, height: 139)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white, lineWidth: 3))
                            } else {
                                ZStack{
                                    // 기본 이미지
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundStyle(Color(hex: "434343"))
                                        .frame(width: 134, height: 139)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white, lineWidth: 3)
                                        )
                                    
                                    Image("DefaultCharacter")
                                }
                            }
                        }
                    }
                    .actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(
                            title: Text("캐릭터 이미지 설정"),
                            buttons: [
                                .default(Text("갤러리에서 사진 선택")) {
                                    showImagePicker = true // 갤러리 열기
                                },
                                .default(Text("기본 이미지로 변경")) {
                                    character.updateImage(nil) // 기본 이미지로 변경
                                },
                                .cancel()
                            ]
                        )
                    }
                    .padding(.bottom, 4)
                    
                    Text("\(character.name)")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    
                    // -MARK: 총점수, 별, 달성률
                    VStack(alignment: .leading) {
                        HStack {
                            Text("총점")
                                .padding(.bottom, 2)
                                .foregroundStyle(.lightGray2)
                                .frame(width: 60, alignment: .leading)
                            
                            Spacer()
                            
                            Rectangle()
                                .frame(width: 160, height: 1)
                                .foregroundStyle(.lightGray2)
                            
                            Spacer()
                            
                            HStack(spacing: 0) {
                                Text("\(calculateScoresAndPasses(for: character).totalScore)")
                                    .foregroundStyle(.pointBlue)
                                Text("점")
                                    .foregroundStyle(.lightGray2)
                            }
                                .padding(.bottom, 2)
                                .fontWeight(.medium)
                                .frame(width: 60, alignment: .trailing)
                        }
                        
                        HStack {
                            Text("별")
                                .padding(.bottom, 2)
                                .foregroundStyle(.lightGray2)
                                .frame(width: 60, alignment: .leading)
                            
                            Spacer()
                            
                            Rectangle()
                                .frame(width: 160, height: 1)
                                .foregroundStyle(.lightGray2)
                            
                            Spacer()
                            
                            HStack(spacing: 0) {
                                Text("\(calculateScoresAndPasses(for: character).totalPasses)")
                                    .foregroundStyle(.pointBlue)
                                Text("개")
                                    .foregroundStyle(.lightGray2)
                            }
                                .padding(.bottom, 2)
                                .fontWeight(.medium)
                                .frame(width: 60, alignment: .trailing)
                        }
                        
                        HStack {
                            Text("달성률")
                                .foregroundStyle(.lightGray2)
                                .frame(width: 60, alignment: .leading)
                            
                            Spacer()
                            
                            // 달성률을 나타내는 바
                            GeometryReader { geometry in
                                let totalQuotes = character.quotes.count
                                let completedQuotes = character.completedQuotes
                                let ratio = totalQuotes > 0 ? CGFloat(completedQuotes) / CGFloat(totalQuotes) : 0
                                
                                AchievementBar(ratio: ratio)
                            }
                            .frame(width: 160, height: 16)
                            
                            Spacer()
                            
                            Text("\(character.completedQuotes)/\(character.quotes.count)")
                                .fontWeight(.medium)
                                .foregroundStyle(.pointBlue)
                                .frame(width: 60, alignment: .trailing)
                        }
                    }
                    .padding()
                    .background(.darkGray)
                    .cornerRadius(16)
                    .padding(.top, 0)
                    .padding(.bottom)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // -MARK: 대사 리스트
                    QuoteListView(character: character, selectedIndex: $selectedIndex, showLearningContent: $showLearningContent)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(selectedImageData: $selectedImage,
                           mode: .photoLibrary)
            }
        }
        .padding()
        .background(Color(hex: "2F2F2F"))
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
        .fullScreenCover(isPresented: $showLearningContent) {
            if let selectedIndex = selectedIndex {
                LearningStartView(quote: character.quotes[selectedIndex], showLearningContent: $showLearningContent)
            }
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
    @Binding var showLearningContent: Bool
    
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
                        // selectedIndex일 때
                        if index == selectedIndex {
                            HStack {
                                Text("#\(index + 1)")
                                    .foregroundStyle(Color(hex: "92FFFD"))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                // 별 표시
                                HStack(spacing: 4) {
                                    ForEach(0..<3) { i in
                                        if i < passCount {
                                            Text(Image(systemName: "star.fill"))
                                                .foregroundStyle(Color(hex: "92FFFD"))
                                        } else {
                                            Text(Image(systemName: "star"))
                                                .foregroundStyle(Color(hex: "92FFFD"))
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
                            
                            // 일본어
                            Text(quote.japanese.joined(separator: " "))
                                .foregroundStyle(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                                .fixedSize(horizontal: false, vertical: true)
                            
                        // selectedIndex가 아닐 때
                        } else {
                            HStack(spacing: 8) {
                                Text("#\(index + 1)")
                                    .foregroundStyle(Color(hex: "92FFFD"))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Text(quote.korean.joined(separator: " "))
                                    .foregroundStyle(.white)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .lineLimit(1) // 글자가 잘려도 되도록 설정
                                
                                Spacer()
                                
                                // 별 표시
                                HStack(spacing: 4) {
                                    ForEach(0..<3) { i in
                                        if i < passCount {
                                            Text(Image(systemName: "star.fill"))
                                                .foregroundStyle(Color(hex: "92FFFD"))
                                        } else {
                                            Text(Image(systemName: "star"))
                                                .foregroundStyle(Color(hex: "92FFFD"))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(index == selectedIndex ? Color.pointBlue : Color.blue1)
                            .stroke(Color(hex: "9EFFFD"), lineWidth: 4)
                    )
                    .id(index)
                    .frame(height: itemHeight)
                    .padding(.vertical, index == selectedIndex ? 26 : 10)
                    .onTapGesture {
                        showLearningContent = true
                        
                        // 마이크 권한 요청
                        AVAudioSession.sharedInstance().requestRecordPermission { granted in
                            if granted {
                                print("마이크 접근 권한이 허용되었습니다.")
                                
                                // 음성 인식 권한 요청
                                // TODO: Speech 권한 허용 위해 Speech를 추가, 구조 분리-변경 필요
                                // TODO: 사용자가 권한 거부할 경우 권한 켜도록 유도 필요(온보딩 만들어주기 or 거부했을 경우 설정에서 켜게 하기)
                                SFSpeechRecognizer.requestAuthorization { authStatus in
                                    DispatchQueue.main.async {
                                        switch authStatus {
                                        case .authorized:
                                            print("음성 인식 권한이 허용되었습니다.")
                                        case .denied:
                                            print("음성 인식 권한이 거부되었습니다.")
                                        case .restricted:
                                            print("음성 인식이 제한되었습니다.")
                                        case .notDetermined:
                                            print("음성 인식 권한이 설정되지 않았습니다.")
                                        @unknown default:
                                            break
                                        }
                                    }
                                }
                                
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
