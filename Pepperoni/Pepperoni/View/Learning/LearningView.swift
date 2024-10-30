//
//  LearningView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI

struct LearningView: View {
    
    let animeId: String
    
    var body: some View {
        VStack {
            Text("애니 ID: \(animeId)")
            
            Button("Finish Learning") {
                Router.shared.navigate(to: .result(score: 90))
            }
        }
    }
}

#Preview {
    LearningView(animeId: "123")
}
