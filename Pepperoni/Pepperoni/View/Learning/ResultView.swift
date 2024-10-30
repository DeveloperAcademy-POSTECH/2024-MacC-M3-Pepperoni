//
//  ResultView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI

struct ResultView: View {
    let score: Int
    
    var body: some View {
        VStack {
            Text("점수: \(score)")
            Button("홈으로 가기") {
                Router.shared.navigateToRoot() // 메인 화면으로 이동
            }
        }
        .navigationTitle("Result")
    }
}

#Preview {
    ResultView(score: 13)
}
