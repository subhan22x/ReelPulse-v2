import SwiftUI

struct RootTabView: View {
    enum Tab: Hashable { case capture, library, digest, settings }

    @State private var selection: Tab = .capture
    let onResetOnboarding: () -> Void

    var body: some View {
        TabView(selection: $selection) {
            CaptureTabView()
                .tabItem {
                    Label("Capture", systemImage: "sparkles")
                }
                .tag(Tab.capture)

            LibraryTabView()
                .tabItem {
                    Label("Library", systemImage: "rectangle.stack.fill")
                }
                .tag(Tab.library)

            DigestTabView()
                .tabItem {
                    Label("Digest", systemImage: "list.bullet.rectangle")
                }
                .tag(Tab.digest)

            SettingsTabView(onResetOnboarding: onResetOnboarding)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(Tab.settings)
        }
    }
}
