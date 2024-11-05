//
//  AnimeDetailView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI

struct CharacterListView: View {
    let anime: Anime

    var body: some View {
        VStack {
            VStack{
                HStack{
                    Spacer()
                    
                    Button(action: {
                        toggleFavorite() // 즐겨찾기 상태 토글
                    }) {
                        Image(systemName: anime.favorite ? "pin.square.fill" : "pin.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                        
                    }
                    .padding(.top)
                }
            
                HStack{
                    Text(anime.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding()
                    
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray2)
            
            // -MARK: 캐릭터 리스트
            List(anime.characters, id: \.id) { character in
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
    
    private func toggleFavorite() {
        anime.favorite.toggle() // favorite 상태를 토글
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
                    .fill(Color.lightGray2)
                
                Rectangle()
                    .fill(Color.skyBlue1)
                    .frame(width: geometry.size.width * ratio, height: 68)
                    .cornerRadius(20)
                    .padding(.bottom, 0)
                
                HStack {
                    if let imageData = character.image, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } else {
                        ZStack{
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                            
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.gray2)
                        }
                    }
                    
                    Text(character.name)
                    
                    Spacer()
                    
                    Text("\(character.completedQuotes) / \(character.quotes.count)")
                        .foregroundStyle(Color.gray2)
                }
                .padding()
                .overlay(
                    character.favorite ?
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.blue1)
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
