//
//  CharacterDetailView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI
import AVFoundation

struct CharacterDetailView: View {
    let character: Character
    
    @State private var selectedIndex: Int? = 0
    @State private var profileImage: Data?
    @State private var isCameraPickerPresented = false
    
    let itemHeight: CGFloat = 58.0
    let menuHeightMultiplier: CGFloat = 5
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .foregroundStyle(.gray1)
                    .frame(height: 584)
                    .cornerRadius(60)
                
                VStack{
                    // -MARK: favorite 버튼
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
                    
                    // -MARK: 캐릭터 프로필
                    ZStack {
                        if let profileImage = profileImage, let image = UIImage(data: profileImage) {
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
            .sheet(isPresented: $isCameraPickerPresented) {
                ImagePickerView(selectedImageData: $profileImage,
                           mode: .photoLibrary)
            }
        }
        .padding()
        .background(.darkGray)
    }
    
    /// 별, 총점수 계산 함수
    private func calculateScoresAndPasses(for character: Character) -> (totalScore: Int, totalPasses: Int) {
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
    
    /// 즐겨찾기 상태 토글 함수
    private func toggleFavorite() {
        character.favorite.toggle() // favorite 상태를 토글
        print("favorite")
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

// -MARK: ImagePicker
struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    @Environment(\.dismiss) var dismiss
    var mode: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = mode
        imagePicker.allowsEditing = true // 사진 편집 기능
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 편집된 이미지 가져오기
        if let editedImage = info[.editedImage] as? UIImage {
            guard let data = editedImage.jpegData(compressionQuality: 0.6) else { return }
            self.picker.selectedImageData = data
        // 편집된 이미지가 없을 경우, 원본 이미지 사용
        } else if let originalImage = info[.originalImage] as? UIImage {
            guard let data = originalImage.jpegData(compressionQuality: 0.6) else { return }
            self.picker.selectedImageData = data
        }
        
        self.picker.dismiss()
    }
}

#Preview {
    CharacterDetailView(character: Character(name: "고죠", favorite: false))
}

