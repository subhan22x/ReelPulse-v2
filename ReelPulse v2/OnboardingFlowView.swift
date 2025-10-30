import SwiftUI

struct OnboardingFlowView: View {
    let onFinish: () -> Void
    @State private var index = 0
    private let steps = DemoContent.onboarding

    var body: some View {
        VStack(spacing: 32) {
            TabView(selection: $index) {
                ForEach(Array(steps.enumerated()), id: \.element.id) { offset, step in
                    OnboardingSlide(step: step)
                        .tag(offset)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .animation(.easeInOut, value: index)

            controlBar
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 32)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
        )
    }

    @ViewBuilder
    private var controlBar: some View {
        if index < steps.count - 1 {
            HStack(spacing: 16) {
                Button("Skip") {
                    onFinish()
                }
                .foregroundStyle(.secondary)

                Spacer()

                Button {
                    withAnimation(.easeInOut) {
                        index = min(index + 1, steps.count - 1)
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text("Next")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(Color.accentColor)
                    )
                    .foregroundColor(.white)
                }
                .buttonStyle(.plain)
            }
        } else {
            Button {
                onFinish()
            } label: {
                Text("Start exploring ReelPulse")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(Color.accentColor)
                    )
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
        }
    }
}

private struct OnboardingSlide: View {
    let step: OnboardingStep

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 0)

            Image(systemName: step.icon)
                .font(.system(size: 56, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(step.accent)
                .padding(20)
                .background(
                    Circle()
                        .fill(step.accent.opacity(0.18))
                )

            Text(step.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(step.message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 420)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 380)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(step.accent.opacity(0.08))
        )
    }
}
