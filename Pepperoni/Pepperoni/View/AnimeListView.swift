//
//  AnimeListView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI
import SwiftData

struct AnimeListView: View {
    @Query(sort: [SortDescriptor(\Anime.title, order: .forward)]) var allAnimes: [Anime]

    private var favoriteAnimes: [Anime] {
        // favorite이 true인 애니메이션만 필터링
        return allAnimes.filter { $0.favorite }
    }
    
    // top: 일단 첫번째 애니메이션으로 설정
    private var topAnime: Anime {
        return allAnimes.first ?? Anime(title: " ", genre: " ")
    }
    
    // 선택된 장르에 따라 필터링된 애니메이션 리스트
    private var filteredAnimes: [Anime] {
        if selectedGenre == "전체" {
            return allAnimes
        } else {
            return allAnimes.filter { $0.genre == selectedGenre }
        }
    }
    
    @State private var text = ""
    @State private var isSearchViewActive: Bool = false
    // 선택된 장르를 저장할 상태 변수
    @State private var selectedGenre: String? = "전체"
    // 장르 배열
    let genres = ["전체", "일상", "판타지/액션", "추리/스릴러", "이세계/판타지", "스포츠", "드라마", "액션/SF", "로맨스"]

    var body: some View {
        
        VStack(spacing: 0) {
            // - MARK: 백버튼, 검색창
            HStack{
                BackButton(color: .black)
                    .frame(height: 40)
                
                SearchBar(searchText: $text)
                    .disabled(true)
                    .onTapGesture {
                        Router.shared.navigate(to: .animeSearch)
                    }
            }
            .padding(.horizontal)
            
            // -MARK: Top Anime 카드
            ZStack(alignment: .bottomTrailing){
                Image("topAnimeCard")
                
                HStack {
                    Spacer()
                    
                    Text("\(topAnime.title)")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                        .padding(.trailing, 28)
                }
            }
            .padding()
            .onTapGesture{
                Router.shared.navigate(to: .characterList(anime: topAnime))
            }
            
            // -MARK: 핀한 애니
            VStack(spacing: 0){
                HStack(spacing: 4) {
                    Text("핀한 애니")
                        .foregroundStyle(.white)
                    
                    Text(Image(systemName: "pin.fill"))
                        .foregroundStyle(.skyBlue1)
                        .rotationEffect(.degrees(48))
                    
                    Spacer()
                }
                .padding(.leading, 20)
                .fontWeight(.bold)
                .frame(height: 38)
                .background(.gray1)
                
                // 핀한 애니가 없을 때
                if favoriteAnimes.isEmpty {
                    HStack (spacing: 8){
                        Image(systemName: "pin.slash.fill")
                            .frame(width: 20)
                        
                        Text("핀한 애니가 없습니다")
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.lightGray2)
                    .padding(26)
                // 핀한 애니가 있을 때
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(favoriteAnimes, id: \.id) { anime in
                                Button {
                                    Router.shared.navigate(to: .characterList(anime: anime))
                                } label: {
                                    HStack (spacing: 6){
                                        ZStack{
                                            Rectangle()
                                                .frame(width: 18, height: 18)
                                                .foregroundStyle(.white)
                                                .cornerRadius(10)
                                            
                                            Image(systemName: "pin.square.fill")
                                                .foregroundStyle(.blue1)
                                                .font(.title3)
                                                .frame(width: 24, height: 24)
                                        }
                                        
                                        Text(anime.title)
                                            .foregroundStyle(.darkGray)
                                    }
                                    .padding(8)
                                    .background(.skyBlue1)
                                    .cornerRadius(6)
                                }
                            }
                        }
                        .padding()
                    }
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
                .background(.gray1)
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
                                    .background(selectedGenre == genre ? Color.blue1 : Color.white)
                                    .foregroundColor(selectedGenre == genre ? .white : .lightGray2)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(selectedGenre == genre ? Color.blue1 : Color.lightGray2, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                }
                
                List(filteredAnimes, id: \.id) { anime in
                    Button {
                        Router.shared.navigate(to: .characterList(anime: anime))
                    } label: {
                        Text(anime.title)
                            .fontWeight(.medium)
                            .foregroundStyle(.darkGray)
                    }
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(.white)
                    .cornerRadius(8)
                    .listRowBackground(Color.lightGray1)
                    .padding(-2)
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
            }
            .background(.lightGray1)
        }
    }
}

#Preview {
    AnimeListView()
}
