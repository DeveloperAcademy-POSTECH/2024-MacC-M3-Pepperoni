//
//  AnimeDetailView.swift
//  Pepperoni
//
//  Created by 변준섭 on 10/28/24.
//
import SwiftUI

struct AnimeDetailView: View {
    var anime: Anime

    var body: some View {
        List(anime.characters) { character in
            Section(header: Text(character.name).font(.headline)) {
                Text("Favorite: \(character.favorite ? "Yes" : "No")")
                    .font(.subheadline)
                
                // 대사 목록
                ForEach(character.quotes) { quote in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Japanese")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack{
                            ForEach(quote.japanese, id: \.self) { line in
                                Text(line)
                                    .font(.body)
                            }
                        }
                        
                        Text("Pronunciation")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack{
                            ForEach(quote.pronunciation, id: \.self) { line in
                                Text(line)
                                    .font(.body)
                            }
                        }
                        
                        Text("Korean")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack{
                            ForEach(quote.korean, id: \.self) { line in
                                Text(line)
                                    .font(.body)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle(anime.title)
    }
}
