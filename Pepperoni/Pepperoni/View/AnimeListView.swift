//
//  AnimeListView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI
import SwiftData

struct AnimeListView: View {
    @Query var allAnimes: [Anime]
    
    let animeArray: [Anime] = [
        Anime(
            title: "하이큐",
            characters: [
                Character(name: "오이카와 토오루", favorite: false)
            ],
            favorite: true
        ),
        Anime(
            title: "원피스",
            characters: [
                Character(name: "빈스모크 상디", favorite: false)
            ],
            favorite: true
        ),
        Anime(
            title: "최애의 아이",
            characters: [
                Character(name: "호시노 아이", favorite: false)
            ],
            favorite: false
        ),
        Anime(
            title: "주술회전",
            characters: [
                Character(name: "고죠 사토루", favorite: false)
            ],
            favorite: false
        )
    ]
    
    var favoriteAnimes: [Anime] {
          // favorite이 true인 애니메이션만 필터링
          return animeArray.filter { $0.favorite }
      }
    
    @State private var text = ""
    @State private var isSearchViewActive: Bool = false
    // 선택된 장르를 저장할 상태 변수
    @State private var selectedGenre: String? = "로맨스"
    // 장르 배열
    let genres = ["전체", "로맨스", "액션", "힐링", "드라마", "코미디"]
    
    var body: some View {
        
        VStack(spacing: 0) {
            // - MARK: 검색창
            Button {
                Router.shared.navigate(to: .animeSearch)
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("애니 검색", text: $text)
                        .foregroundColor(.blue)
                        .padding(.vertical, 10)
                }
                .padding(.horizontal)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .disabled(true)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
            
            // -MARK: Top Anime 카드
            ZStack(alignment: .bottomTrailing){
                Image("topAnimeCard")
                
                HStack {
                    Spacer()
                    
                    Text("주술회전")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                        .padding(.trailing, 28)
                }
            }
            .padding()
            
            // -MARK: 핀한 애니
            VStack(spacing: 0){
                HStack(spacing: 4) {
                    Text("핀한 애니")
                        .foregroundStyle(.white)
                    
                    Text(Image(systemName: "pin.fill"))
                        .foregroundStyle(.blue)
                        .rotationEffect(.degrees(48))
                    
                    Spacer()
                }
                .padding(.leading, 20)
                .fontWeight(.bold)
                .frame(height: 38)
                .background(.black)
                
                ScrollView(.horizontal) {
                    HStack {
                        // TODO: allAnimes 로 배열 변경
                        ForEach(favoriteAnimes, id: \.id) { anime in
                            Button {
                                Router.shared.navigate(to: .characterList(anime: anime))
                            } label: {
                                HStack {
                                    Text(Image(systemName: "pin.square.fill"))
                                        .foregroundStyle(.blue)
                                        .font(.title3)
                                    
                                    Text(anime.title)
                                        .foregroundStyle(.black)
                                }
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(6)
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // -MARK: 전체 애니
            VStack{
                HStack {
                    Text("전체 애니")
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.leading, 20)
                .frame(height: 38)
                .background(.black)
                .fontWeight(.bold)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(genres, id: \.self) { genre in
                            Button(action: {
                                selectedGenre = genre
                            }) {
                                Text(genre)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(selectedGenre == genre ? Color.ppBlue : Color.white)
                                    .foregroundColor(selectedGenre == genre ? .white : .gray)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(selectedGenre == genre ? Color.ppBlue : Color.gray, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                }
                
                List(animeArray, id: \.id) { anime in
                    Button {
                        Router.shared.navigate(to: .characterList(anime: anime))
                    } label: {
                        Text(anime.title)
                    }
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(.white)
                    .cornerRadius(8)
                    .listRowBackground(Color.gray)
                    .padding(-2)
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
            }
            .background(.gray)
        }
    }
}

#Preview {
    AnimeListView()
}
