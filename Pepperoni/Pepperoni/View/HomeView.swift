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
        VStack(spacing: 20) {
            HStack (spacing: 12){
                Text("anisentence")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                } label: {
                    Image("Namecard")
                }
                
                Button {
                } label: {
                    Text(Image(systemName: "info.circle"))
                        .font(.title2)
                        .foregroundStyle(.gray)
                }
            }
            .frame(height: 70)
            
            VStack{
                Image("Roni")
            }
            .frame(maxWidth: .infinity, maxHeight: 291)
            .background(.secondary)
            .cornerRadius(20)
            
            Button {
                Router.shared.navigate(to: .animeList)
            } label: {
                HStack{
                    Text(Image(systemName: "list.bullet"))
                    
                    Text("애니 목록")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 60)
            .foregroundStyle(.white)
            .background(.secondary)
            .cornerRadius(16)
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 245)
                .cornerRadius(16)
                .foregroundStyle(.ppBlue)
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
