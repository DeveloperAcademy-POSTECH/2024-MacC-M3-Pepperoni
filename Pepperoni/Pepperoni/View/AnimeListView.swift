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
    
    var body: some View {
        
        // - MARK: 애니 리스트
        VStack {
            VStack {
                // - MARK: 검색창 (TextField를 Button으로 감쌈)
                Button {
                    Router.shared.navigate(to: .animeSearch)
                } label: {
                    HStack {
                        TextField("애니를 검색해보세요", text: $text)
                            .padding()
                            .background(.gray)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(true) // 사용자가 직접 수정할 수 없게 비활성화
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            // -MARK: 핀한 애니
            VStack{
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
                    LazyHStack {
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
                                }
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(6)
                            }
                            .buttonStyle(PlainButtonStyle()) // 버튼 스타일을 기본으로 설정
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
