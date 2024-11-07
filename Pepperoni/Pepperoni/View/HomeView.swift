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
                        .foregroundStyle(Color(hex: "BAE2FF"))
                    
                    // 최애 캐릭터가 없을 때
                    if favoriteCharacters.isEmpty {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.blueWhite)
                            .padding(.horizontal, 11)
                            .padding(.top, 20)
                            .padding(.bottom, 46)
                        
                        VStack(spacing: 8) {
                            Image(systemName: "person.slash.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .foregroundColor(.lightGray2)
                                .padding(.bottom, 9)
                            
                            Text("[최애]에게 하트를 눌러주세요")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.lightGray2)
                            
                            Text("하트를 누르면 캐릭터 카드가 생성됩니다")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.lightGray2)
                        }
                        .padding(.bottom, 24)
                        
                        //최애 캐릭터가 존재할 때
                    } else {
                        TabView{
                            ForEach(favoriteCharacters) { character in
                                let totalQuotes = character.quotes.count
                                let completedQuotes = character.completedQuotes
                                let ratio = totalQuotes > 0 ? CGFloat(completedQuotes) / CGFloat(totalQuotes) : 0
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(Color.skyBlue1)
                                    
                                    ZStack(alignment: .bottom){
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(Color(hex: "EFFBFF"))
                                            .padding(3)
                                            .padding(.bottom, 14)
                                        Rectangle()
                                            .foregroundStyle(Color.skyBlue1)
                                            .frame(height:30)
                                            .padding(.bottom, 15)
                                            .overlay{
                                                HStack{
                                                    Spacer()
                                                    Text("란스 크라운")
                                                        .font(.system(size: 22, weight: .heavy))
                                                        .foregroundStyle(Color.pointBlue)
                                                    Image(systemName:"chevron.right")
                                                        .resizable()
                                                        .frame(width:11, height:18)
                                                        .foregroundStyle(Color.blue1)
                                                }.padding(.trailing, 17)
                                             
                                            }
                                    }
                                    
                                    
                                    
                                    VStack {
                                        HStack {
                                            // 캐릭터 default image
                                            VStack{
                                                ZStack {
                                                    Rectangle()
                                                        .foregroundStyle(Color(hex: "434343"))
                                                        .frame(width: 136, height: 150)
                                                        .cornerRadius(22)
                                                    
                                                    Image("DefaultCharacter")
                                                }
                                                Spacer()
                                            }
                                            
                                            VStack{
                                                // 애니 이름 + 하트
                                                HStack{
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .foregroundStyle(.skyBlue2)
                                                        .frame(width: 80, height:26)
                                                        .overlay{
                                                            Text(character.anime?.title ?? "")
                                                                .font(.system(size: 14, weight: .medium))
                                                                .foregroundStyle(.blue1)
                                                        }
                                                    
                                                    Spacer()
                                                    
                                                    Image(systemName: "heart.fill")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 26)
                                                        .foregroundColor(.blue1)
                                                }
                                                
                                                Spacer()
                                                    .frame(height: 28)
                                                
                                                HStack{
                                                    Spacer()
                                                    
                                                    Text("캐릭터 달성률")
                                                        .font(.system(size: 14))
                                                    
                                                }
                                                
                                                Spacer()
                                                
                                                CharacterRowInHome(character: character, ratio: ratio)
                                                    .frame(height:20)
                                                    .padding(.bottom, 25)
                                                Spacer()
                                                
                                                
                                            }
                                            .padding(20)
                                        }
                                        
                                        Spacer()
                                    }
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
                .frame(maxWidth: .infinity, minHeight: 245)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("anisentence")
                    .fontWeight(.bold)
                    .foregroundStyle(.gray1)
            }
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
                    Spacer()
                    Text("\(character.completedQuotes) / \(character.quotes.count)")
                        .foregroundStyle(Color.pointBlue)
                }
                .padding()
            }
            .frame(height: 26)
            .cornerRadius(20)
        }
    }
}
