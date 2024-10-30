//
//  MainView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    var body: some View {
        DataLoadingView()
        VStack {
            HStack {
                Text("anisentence")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.ppBlue)
                Spacer()
            }
            .frame(height: 70)
            
            Group{
                Image("Roni")
                
                Button("애니 목록") {
                    Router.shared.navigate(to: .animeList)
                }
                .frame(width: 357, height: 60)
                .foregroundStyle(.white)
                .background(.ppBlue)
                .cornerRadius(16)
            }
            
            Group{
                Rectangle()
                    .frame(width: 360, height: 180)
                    .cornerRadius(16)
                    .foregroundStyle(.ppBlue)
                
//                Button("최애의 아이") {
//                    Router.shared.navigate(to: .learning(character: Character))
//                }
//                .frame(width: 180, height: 60)
//                .foregroundStyle(.white)
//                .background(.ppBlue)
//                .cornerRadius(16)
            }
        }
        .padding()

    }
}

#Preview {
    HomeView()
}
