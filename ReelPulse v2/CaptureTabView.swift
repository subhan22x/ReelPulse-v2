import SwiftUI

struct CaptureTabView: View {
    @State private var selectedDestination: ShareDestination?
    @State private var showHowItWorks = false

    private let shareDestinations = DemoContent.shareDestinations

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    introSection
                    shareSection
                    highlightSection
                }
                .padding()
            }
            .navigationTitle("Capture")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showHowItWorks.toggle()
                    } label: {
                        Label("How it works", systemImage: "questionmark.circle")
                    }
                }
            }
            .sheet(item: $selectedDestination) { destination in
                ShareDestinationSheet(destination: destination)
            }
            .sheet(isPresented: $showHowItWorks) {
                NavigationStack {
                    Form {
                        Section("Capturing clips") {
                            Text("Use the iOS share sheet from any social app to send short-form videos to ReelPulse. We transcribe the audio and capture the highlights automatically.")
                        }
                        Section("Tips") {
                            Label("Pin the ReelPulse extension for faster access", systemImage: "pin.fill")
                            Label("Long-press a saved clip to add it directly to a project", systemImage: "hand.point.up.left.fill")
                        }
                    }
                    .navigationTitle("How it works")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") {
                                showHowItWorks = false
                            }
                        }
                    }
                }
            }
        }
    }

    private var introSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Convert short-form videos into insights")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Share or paste a link from Instagram, TikTok, YouTube or Pinterest. ReelPulse keeps the transcript, tags, and action items ready for you.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var shareSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Share from your favourite apps")
                .font(.headline)

            Text("Tap an app below to simulate sending a clip. The buttons demonstrate the share flow for the demo.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 16)], spacing: 16) {
                ForEach(shareDestinations) { destination in
                    ShareDestinationButton(destination: destination) {
                        selectedDestination = destination
                    }
                }
            }

            PrimaryButton(title: "Open share extension", icon: "square.and.arrow.up") {
                selectedDestination = ShareDestination.shareExtension
            }
        }
    }

    private var highlightSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Latest capture summary")
                .font(.headline)

            CaptureSummaryCard()
        }
    }
}

private struct ShareDestinationButton: View {
    let destination: ShareDestination
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Image(systemName: destination.icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(destination.color)
                    .frame(width: 60, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(destination.color.opacity(0.15))
                    )
                Text(destination.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                Text("Send clip")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, minHeight: 140)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(destination.color.opacity(0.08))
            )
        }
        .buttonStyle(.plain)
    }
}

private struct CaptureSummaryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Knitting design breakdown")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Captured 2 minutes ago")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("NEW")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.teal.opacity(0.2))
                    )
                    .foregroundStyle(Color.teal)
            }

            Text("We found three actionable steps, the supply list, and tagged this clip under \"Crafts\" for you.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                Label("3 step-by-step instructions saved", systemImage: "list.bullet.rectangle")
                Label("Supplies automatically highlighted", systemImage: "sparkles")
                Label("Suggested project: Knitting design ideas", systemImage: "folder.fill")
            }
            .font(.footnote)
            .symbolRenderingMode(.hierarchical)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.teal.opacity(0.08))
        )
    }
}

private struct PrimaryButton: View {
    let title: String
    var icon: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.accentColor)
            )
            .foregroundColor(.white)
        }
        .buttonStyle(.plain)
    }
}

private struct ShareDestinationSheet: View {
    @Environment(\.dismiss) private var dismiss
    let destination: ShareDestination
    @State private var hasQueuedExample = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Send from \(destination.name)")) {
                    Text(destination.description)
                        .font(.body)
                }

                Section("Demo action") {
                    Button {
                        withAnimation(.easeInOut) {
                            hasQueuedExample.toggle()
                        }
                    } label: {
                        Label(hasQueuedExample ? "Clip queued" : "Simulate sending a clip",
                              systemImage: hasQueuedExample ? "checkmark.circle.fill" : "paperplane.fill")
                    }
                    if hasQueuedExample {
                        Text("Great! The video now appears in your library with tags and notes.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle(destination.name)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
