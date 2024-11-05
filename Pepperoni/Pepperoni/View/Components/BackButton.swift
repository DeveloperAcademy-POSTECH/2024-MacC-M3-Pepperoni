//
//  BackButton.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 11/5/24.
//

import SwiftUI

struct BackButton: View {
    var color: Color = .white // 기본 색상 - white
    
    var body: some View {
        Button {
            Router.shared.navigateBack()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(color)
        }
    }
}

#Preview {
    BackButton()
}
