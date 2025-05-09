//
//  Badge.swift
//  Gigadex
//
//  Created by Ryan Token on 5/9/25.
//

import SwiftUI

struct Badge: ViewModifier {
    var backgroundColor: Color

    func body(content: Content) -> some View {
        content
            .fontWeight(.semibold)
            .padding(2)
            .padding(.horizontal)
            .background(backgroundColor.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension View {
    func badgeStyle(using backgroundColor: Color) -> some View {
        modifier(Badge(backgroundColor: backgroundColor))
    }
}
