//
//  AnimeDetailView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI

struct CharacterListView: View {
    let anime: Anime
    
    var sortedCharacters: [Character] {
        anime.characters.sorted {
            if $0.favorite == $1.favorite {
                return $0.name < $1.name
            }
            return $0.favorite && !$1.favorite
        }
    }

    var body: some View {
        VStack {
            HStack(alignment: .bottom){
                Text(anime.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 74)
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity)
            .background(Color.gray2)
            
            // -MARK: 캐릭터 리스트
            List(sortedCharacters, id: \.id) { character in
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
        // -MARK: NavigationBar
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    toggleFavorite()
                }) {
                    Image(systemName: anime.favorite ? "pin.square.fill" : "pin.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)

                        .foregroundColor(anime.favorite ? Color.blue1 : .white)
                }
            }
        }
    }
    
    /// 즐겨찾기 상태 토글 함수
    private func toggleFavorite() {
        anime.favorite.toggle()
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
                    .fill(Color.lightGray1)
                
                Rectangle()
                    .fill(Color(hex: "A9DBFF"))
                    .frame(width: geometry.size.width * ratio, height: 68)
                    .cornerRadius(20)
                    .padding(.bottom, 0)
                
                HStack {
                    if let imageData = character.image, let uiImage = UIImage(data: imageData) {
                        ZStack{
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay{
                                    if character.favorite{
                                        ZStack{
                                            Image(systemName: "heart.fill")
                                                .resizable()
                                                .frame(width:18, height:17)
                                                .foregroundStyle(.blue1)
                                            Image(systemName: "heart.fill")
                                                .resizable()
                                                .frame(width:16, height:15)
                                                .foregroundStyle(.pointBlue)
                                        }
                                        .offset(x:-14, y:-14)
                                    }
                                }
                        }
                    } else {
                        ZStack{
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                            
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.gray2)
                                .overlay{
                                    if character.favorite{
                                        ZStack{
                                            Image(systemName: "heart.fill")
                                                .resizable()
                                                .frame(width:18, height:17)
                                                .foregroundStyle(.blue1)
                                            Image(systemName: "heart.fill")
                                                .resizable()
                                                .frame(width:16, height:15)
                                                .foregroundStyle(.pointBlue)
                                        }
                                        .offset(x:-14, y:-14)
                                    }
                                }
                        }
                    }
                    
                    Text(character.name)
                    
                    Spacer()
                    
                    Text("\(character.completedQuotes) / \(character.quotes.count)")
                        .foregroundStyle(Color.gray2)
                }
                .padding()
            }
            .frame(height: 68)
            .cornerRadius(20)
        }
    }
}

#Preview {
    CharacterListView(anime: Anime(title: "hihi", genre:"asd"))
}
