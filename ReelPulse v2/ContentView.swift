import SwiftUI

struct ContentView: View {
    @State private var hasCompletedOnboarding = false

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                RootTabView(onResetOnboarding: resetOnboarding)
            } else {
                OnboardingFlowView(onFinish: completeOnboarding)
            }
        }
        .transition(.opacity.combined(with: .scale))
    }

    private func completeOnboarding() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            hasCompletedOnboarding = true
        }
    }

    private func resetOnboarding() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            hasCompletedOnboarding = false
        }
    }
}

#Preview {
    ContentView()
}
