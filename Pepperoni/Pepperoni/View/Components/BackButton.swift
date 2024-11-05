//
//  BackButton.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 11/5/24.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    // 기본 색상 - white
    var color: Color = .white
    
    var body: some View {
        Button {
            self.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(color)
        }
    }
}

#Preview {
    BackButton()
}
