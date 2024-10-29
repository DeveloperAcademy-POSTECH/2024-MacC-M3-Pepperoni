//
//  LoadingView.swift
//  Pepperoni
//
//  Created by 변준섭 on 10/29/24.
//

import SwiftUI
import SwiftData

struct DataLoadingView: View{
    @Environment(\.modelContext) private var modelContext
    @Query private var animes: [Anime]
    @State private var isDataLoaded = false
    
    var body: some View{
        Text("JSON 파싱을 위한 뷰")
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
    DataLoadingView()
}
