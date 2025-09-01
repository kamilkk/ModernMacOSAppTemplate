//
//  Extensions.swift
//  Modern macOS App Template
//
//  Created by Developer on $(date).
//

import SwiftUI
import Foundation

// MARK: - String Extensions
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }

    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

// MARK: - View Extensions
extension View {
    /// Adds a border with the specified color and width
    func border(_ color: Color, width: CGFloat = 1) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(color, lineWidth: width)
        )
    }

    /// Adds a corner radius to the view
    func cornerRadius(_ radius: CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius))
    }

    /// Conditionally applies a modifier
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Applies a modifier conditionally with an else case
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }

    /// Hides the view based on a condition
    @ViewBuilder
    func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }

    /// Applies a background blur effect
    func backgroundBlur() -> some View {
        background(.ultraThinMaterial)
    }

    /// Adds haptic feedback on tap
    func hapticFeedback(_ style: NSHapticFeedbackManager.FeedbackPattern = .generic) -> some View {
        onTapGesture {
            NSHapticFeedbackManager.defaultPerformer.perform(style, performanceTime: .default)
        }
    }
}

// MARK: - Color Extensions
extension Color {
    /// Creates a color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    /// Returns the hex string representation of the color
    var hexString: String {
        let nsColor = NSColor(self)
        guard let ciColor = CIColor(color: nsColor) else {
            return "#000000"
        }
        return String(
            format: "#%02X%02X%02X",
            Int(ciColor.red * 255),
            Int(ciColor.green * 255),
            Int(ciColor.blue * 255)
        )
    }
}

// MARK: - Date Extensions
extension Date {
    var timeAgoDisplay: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    func formatted(_ style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
}

// MARK: - Array Extensions
extension Array {
    /// Safely access array elements
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    /// Remove duplicates from array
    func removingDuplicates<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}

// MARK: - Publisher Extensions
import Combine

extension Publisher {
    /// Assigns to multiple properties
    func assign<Root: AnyObject>(
        to keyPaths: [ReferenceWritableKeyPath<Root, Output>],
        on object: Root
    ) -> AnyCancellable where Self.Failure == Never {
        sink { value in
            for keyPath in keyPaths {
                object[keyPath: keyPath] = value
            }
        }
    }

    /// Debounce and run on main queue
    func debounceAndMain<S: Scheduler>(
        for dueTime: S.SchedulerTimeType.Stride,
        scheduler: S
    ) -> Publishers.ReceiveOn<Publishers.Debounce<Self, S>, DispatchQueue> {
        debounce(for: dueTime, scheduler: scheduler)
            .receive(on: DispatchQueue.main)
    }
}

// MARK: - UserDefaults Extensions
extension UserDefaults {
    func set<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(object) {
            set(data, forKey: key)
        }
    }

    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}

// MARK: - FileManager Extensions
extension FileManager {
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static var applicationSupportDirectory: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    }

    func fileSize(at url: URL) -> Int64? {
        guard let attributes = try? attributesOfItem(atPath: url.path) else { return nil }
        return attributes[.size] as? Int64
    }
}
