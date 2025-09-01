//
//  AppStyles.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI

// MARK: - App Colors
extension Color {
    static let appBackgroundColor = Color(NSColor.controlBackgroundColor)
    static let cardBackgroundColor = Color(NSColor.controlColor)
    static let textPrimaryColor = Color.primary
    static let textSecondaryColor = Color.secondary
}

// MARK: - App Fonts
extension Font {
    static let appTitle = Font.system(size: 24, weight: .bold, design: .default)
    static let appHeadline = Font.system(size: 18, weight: .semibold, design: .default)
    static let appBody = Font.system(size: 14, weight: .regular, design: .default)
    static let appCaption = Font.system(size: 12, weight: .regular, design: .default)
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.appBody)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.appBody)
            .fontWeight(.medium)
            .foregroundColor(.primary)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color(white: 0.9))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Card Style
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

// MARK: - Loading State
struct LoadingModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        content
            .disabled(isLoading)
            .overlay {
                if isLoading {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.regularMaterial)
                        .overlay {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                }
            }
    }
}

extension View {
    func loading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }
}
