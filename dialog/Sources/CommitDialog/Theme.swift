import SwiftUI

// Anthropic like palette with warm orange accent on translucent cream/charcoal.
enum Theme {
    static let accent = Color(red: 0xD9 / 255, green: 0x77 / 255, blue: 0x57 / 255)  // #D97757
    static let accentSoft = Color(red: 0xD9 / 255, green: 0x77 / 255, blue: 0x57 / 255).opacity(0.18)
    static let surface = Color(red: 0xF9 / 255, green: 0xF4 / 255, blue: 0xED / 255).opacity(0.05)
    static let stroke = Color.white.opacity(0.12)
}
