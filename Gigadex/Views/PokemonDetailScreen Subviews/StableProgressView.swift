//
//  StableProgressView.swift
//  Gigadex
//
//  Created by Ryan Token on 5/9/25.
//

import SwiftUI

struct StableProgressView: View {
    let value: Double
    @State private var animatedValue: Double = 0
    @State private var hasAnimated = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray.opacity(0.3))
                    .frame(height: 8)

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor)
                    .frame(width: geometry.size.width * animatedValue, height: 8)
            }
        }
        .frame(height: 8)
        .padding(3)
        .onAppear {
            if !hasAnimated {
                withAnimation(.easeInOut(duration: 0.8)) {
                    animatedValue = value
                }
                hasAnimated = true
            }
        }
    }
}

#Preview {
    StableProgressView(value: 0.75)
}
