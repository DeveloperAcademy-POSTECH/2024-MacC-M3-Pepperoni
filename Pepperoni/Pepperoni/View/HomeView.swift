//
//  MainView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @State private var isDataLoaded = false
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Character> { $0.favorite == true })
    private var favoriteCharacters: [Character]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 12) {
                // MARK: - 말풍선, 캐릭터 영역
                ZStack {
                    VStack(spacing: 13) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 65)
                                .foregroundStyle(.white)
                            
                            Text("오늘은 어떤 대사를\n함께 따라 말해볼까요 ?")
                                .foregroundStyle(Color(hex: "353535"))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                        }
                        .frame(height: 141)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 40, height: 18)
                            .padding(.trailing, 27)
                            .foregroundStyle(Color(hex: "D9D9D9"))
                        
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 27, height: 12)
                            .foregroundStyle(Color(hex: "949494"))
                        
                        Spacer()
                    }
                    
                    VStack{
                        Spacer()
                        
                        HStack{
                            Spacer()
                            
                            Image("Roni")
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .padding(.vertical, 26)
                .padding(.horizontal, 31)
                .background(Color(hex: "353535"))
                .cornerRadius(20)
                
                Button {
                    Router.shared.navigate(to: .animeList)
                } label: {
                    HStack{
                        Text(Image(systemName: "list.bullet"))
                            .font(.title2)
                            .fontWeight(.medium)
                            .frame(width: 40, height: 40)
                            .background(Color(hex: "2E2E2E"))
                            .clipShape(.circle)
                        
                        Spacer()
                        
                        Text("애니 목록")
                            .fontWeight(.medium)
                        
                        Spacer()
                            .frame(width: 130)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .foregroundStyle(.skyBlue2)
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .foregroundStyle(.white)
                .background(Color.darkGray)
                .cornerRadius(16)
            
                ZStack{
                    Rectangle()
                        .cornerRadius(16)
                        .foregroundStyle(Color.skyBlue1)
                    
                    // 최애 캐릭터가 없을 때
                    if favoriteCharacters.isEmpty {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.blueWhite)
                            .padding(.horizontal, 11)
                            .padding(.top, 20)
                            .padding(.bottom, 46)
                        
                        VStack(spacing: 10) {
                            Image(systemName: "person.slash.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .foregroundColor(.lightGray2)
                            
                            Text("설정한 최애가 없습니다")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.lightGray2)
                            
                            Text("하트를 눌러 최애를 설정해 주세요")
                                .font(.system(size: 14))
                                .foregroundColor(.lightGray2)
                        }
                        .padding()
                        
                    //최애 캐릭터가 존재할 때
                    } else {
                        TabView{
                            ForEach(favoriteCharacters) { character in
                                let totalQuotes = character.quotes.count
                                let completedQuotes = character.completedQuotes
                                let ratio = totalQuotes > 0 ? CGFloat(completedQuotes) / CGFloat(totalQuotes) : 0
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(Color.blueWhite)
                                    
                                    HStack(spacing:26){
                                        ZStack {
                                            Rectangle()
                                                .foregroundStyle(.lightGray2)
                                                .frame(width: 131, height: 139)
                                                .cornerRadius(12)
                                            
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .frame(width: 82, height: 87)
                                                .foregroundStyle(.white)
                                        }
                                        
                                        VStack{
                                            RoundedRectangle(cornerRadius: 16)
                                                .foregroundStyle(Color.lightGray1)
                                                .frame(height:52)
                                                .overlay{
                                                    Text(character.anime?.title ?? "")
                                                        .font(.system(size: 20, weight: .bold))
                                                        .foregroundStyle(Color.darkGray)
                                                }
                                            
                                            Spacer()
                                            
                                            HStack{
                                                Text(character.name)
                                                    .foregroundStyle(Color.blue1)
                                                    .font(.system(size: 20, weight: .bold))
                                                
                                                Spacer()
                                                
                                                Text("달성률")
                                                    .foregroundStyle(Color.lightGray2)
                                                    .font(.system(size: 14, weight: .bold))
                                            }
                                            
                                            CharacterRowInHome(character: character, ratio: ratio)
                                                .frame(height:26)
                                                .padding(.bottom, 12)
                                            
                                        }
                                    }
                                    .padding(.horizontal, 13)
                                    .padding(.vertical, 14.5)
                                }
                                .frame(height: 179)
                                .padding(.horizontal, 11.5)
                                .padding(.bottom, 20)
                                .onTapGesture {
                                    Router.shared.navigate(to: .characterDetail(character: character))
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 245)
            }
            .padding()
        }
        .onAppear {
            if isFirstLaunch() {
                JSONUtils.saveAnimeCharacterData(modelContext: modelContext)
                JSONUtils.saveAnimeQuotesData(modelContext: modelContext)
                isDataLoaded = true
            } else {
                isDataLoaded = true
            }
        }
    }
    
    private func isFirstLaunch() -> Bool {
        let key = "isFirstLaunch"
        let isFirst = !UserDefaults.standard.bool(forKey: key)
        if isFirst {
            UserDefaults.standard.set(true, forKey: key)
        }
        return isFirst
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
                    .fill(Color.gray2)
                
                Rectangle()
                    .fill(Color.blue1)
                    .frame(width: geometry.size.width * ratio, height: 68)
                    .cornerRadius(20)
                
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
