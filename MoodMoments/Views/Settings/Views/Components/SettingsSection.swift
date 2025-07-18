import SwiftUI

struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    var body: some View {
        Section(title) {
            content()
        }
    }
} 