//
//  SearchBar.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/31/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가기 위한 환경 변수

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("애니 검색", text: $searchText)
                    .foregroundColor(.blue)
                    .padding(.vertical, 10)
            }
            .padding(.horizontal)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            
            Button("Cancel") {
                searchText = ""
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.black)
            .padding(.leading, 8)
        }
        .padding()
    }
}

#Preview {
    SearchBar(searchText: .constant(""))
}
