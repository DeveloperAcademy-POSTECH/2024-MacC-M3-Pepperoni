//
//  MainView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Query private var characters: [Character]
    
    var body: some View {
        GeometryReader { geometry in
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
                    SpeechBubbleRight()
                        .padding(.horizontal, 39)
                        .padding(.top, 32)
                        .overlay{
                            Text("우리 잠 언제 자?")
                                .foregroundStyle(.white)
                        }
                    HStack{
                        Spacer()
                        Image("Roni")
                            .resizable()
                            .scaledToFit()
                            .frame(width:103)
                            .padding(.trailing, 36)
                        
                    }
                    
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
                TabView{
                    ForEach(characters) { character in
                        let totalQuotes = character.quotes.count
                        let completedQuotes = character.completedQuotes
                        let ratio = totalQuotes > 0 ? CGFloat(completedQuotes) / CGFloat(totalQuotes) : 0
                        
                        ZStack{
                            Rectangle()
                                .cornerRadius(16)
                                .foregroundStyle(.ppBlue)
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                
                                HStack(spacing:26){
                                    Image("Roni")
                                        .background{
                                            Color.white
                                        }
                                        .cornerRadius(12)
                                    
                                    
                                    VStack{
                                        RoundedRectangle(cornerRadius: 16)
                                            .foregroundStyle(.white)
                                            .frame(height:52)
                                            .overlay{
                                                Text(character.anime?.title ?? "")
                                            }
                                        Spacer()
                                        HStack{
                                            Text(character.name)
                                            Spacer()
                                            Text("달성률")
                                        }
                                        .foregroundStyle(.white)
                                        
                                        CharacterRowInHome(character: character, ratio: ratio)
                                            .frame(height:26)
                                            .padding(.bottom, 12)

                                    }
                                }.padding(.horizontal, 13)
                                    .padding(.vertical, 14.5)
                            }
                            .frame(height: 179)
                            .padding(.horizontal, 11.5)
                            
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(maxWidth: .infinity, maxHeight: 245)
                
                
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}

struct CharacterRowInHome: View {
    var character: Character
    var ratio: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray)
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * ratio, height: 68)
                    .cornerRadius(20)
                    .padding(.bottom, 0)
                
                HStack {
                    Text("\(character.completedQuotes) / \(character.quotes.count)")
                    Spacer()
                }
                .padding()
            }
            .frame(height: 26)
            .cornerRadius(20)
        }
    }
}

struct SpeechBubbleRight: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 말풍선 본체
        path.addRoundedRect(in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height * 0.93), cornerSize: CGSize(width: 16, height: 16))
        
        // 꼬리 부분
        path.move(to: CGPoint(x: rect.width * 0.75, y: rect.height * 0.93))
        path.addLine(to: CGPoint(x: rect.width * 0.8, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width * 0.85, y: rect.height * 0.93))
        path.closeSubpath()
        
        return path
    }
}
