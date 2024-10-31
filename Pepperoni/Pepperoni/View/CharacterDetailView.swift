//
//  CharacterDetailView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        List(character.quotes, id: \.id) { quote  in
            Button {
                Router.shared.navigate(to: .learningStart(quote: quote))
            } label: {
                Text("\(quote.korean)")
            }
        }
    }
}

#Preview {
    CharacterDetailView(character: Character(name: "고죠", favorite: false))
}

