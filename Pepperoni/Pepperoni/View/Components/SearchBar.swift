//
//  SearchBar.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/31/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.lightGray2)
                
            TextField("애니 검색", text: $searchText)
                .foregroundColor(.blue)
                .padding(.vertical, 10)
                .font(.body)
        }
        .padding(.horizontal)
        .background(.lightGray1)
        .cornerRadius(6)
    }
}

#Preview {
    SearchBar(searchText: .constant(""))
}
