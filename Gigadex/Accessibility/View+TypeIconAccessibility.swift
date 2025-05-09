//
//  View+TypeIconAccessibility.swift
//  Gigadex
//
//  Created by Ryan Token on 5/9/25.
//

import SwiftUI

extension View {
    func typeIconAccessibility(for type: Type) -> some View {
        self
            .accessibilityLabel("\(type.name) type")
            .accessibilityHidden(false)
    }
}
