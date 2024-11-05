//
//  AchievementBar.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 11/5/24.
//

import SwiftUI

struct AchievementBar: View {
    var ratio: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.darkGray)
                
                Rectangle()
                    .fill(Color.blue1)
                    .frame(width: geometry.size.width * ratio, height: 20)
                    .cornerRadius(20)
                    .padding(.bottom, 0)
            }
            .frame(height: 20)
            .cornerRadius(20)
        }
    }
}
