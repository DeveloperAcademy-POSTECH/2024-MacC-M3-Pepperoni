//
//  SearchView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI
import SwiftData

struct AnimeSearchView: View {
    @Query var allAnimes: [Anime]
    @State private var searchText: String = ""
    
    private var filteredAnimes: [Anime] {
        allAnimes.filter { !$0.title.isEmpty && searchText.isEmpty == false && $0.title.contains(searchText) }
    }

    var body: some View {
        VStack {
            HStack{
                SearchBar(searchText: $searchText)
                
                Button("Cancel") {
                    searchText = ""
                    Router.shared.navigateBack()
                }
                .foregroundColor(.black)
                .padding(.leading, 8)
            }
            .padding(.horizontal)
        
            if !filteredAnimes.isEmpty {
                List(filteredAnimes, id: \.id) { anime in
                    Button {
                        Router.shared.navigate(to: .characterList(anime: anime))
                    } label: {
                        HStack {
                            Text(anime.title)
                                .foregroundColor(.gray1)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray2)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
        }
    }
}

#Preview {
    AnimeSearchView()
}
