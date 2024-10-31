//
//  AnimeDetailView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI

struct CharacterListView: View {
    let anime: Anime
    
    var dummieAnime : Anime = Anime(title: "원피스", characters:  [
        Character(name: "몽키 디 루피", favorite: true),
        Character(name: "토니토니 초파", favorite: true),
        Character(name: "롤로노아 조로", favorite: false),
        Character(name: "니코 로빈", favorite: false),
        Character(name: "상디", favorite: false)
    ])

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
            
            List(dummieAnime.characters, id: \.id) { character in
                Button {
                    Router.shared.navigate(to: .characterList(anime: anime))
                } label: {
                    HStack {
                        Circle()
                            .frame(width: 40, height: 40)
                        Text(character.name)
                        
                        Spacer()
                        
                        Text("3 / 10")
                    }
                    .padding()
                    .overlay(
                        // favorite이 true일 때 하트 아이콘 표시
                        character.favorite ?
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                            .font(.title3)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .offset(x: -10, y: 0) : nil,
                        alignment: .topLeading
                    )
                }
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity)
                .frame(height: 68)
                .background(.gray)
                .cornerRadius(20)
                .padding(-2)
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)

            Spacer()
        }
        .navigationTitle(anime.title)
    }
}

#Preview {
    CharacterListView(anime: Anime(title: "hihi"))
}
