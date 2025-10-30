import SwiftUI

struct DigestTabView: View {
    @State private var highlights: [DigestHighlight] = DemoContent.digestHighlights
    @State private var showPinnedOnly = false

    private var filteredIndices: [Int] {
        highlights.indices.filter { index in
            !showPinnedOnly || highlights[index].isPinned
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    header
                    controls
                    ideasList
                }
                .padding()
            }
            .navigationTitle("Digest")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weekly digest")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Here are the themes you saved the most this week.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TagCloud(tags: ["Home furnishing", "Finance routines", "Creative prompts"])
        }
    }

    private var controls: some View {
        HStack(spacing: 16) {
            Toggle(isOn: $showPinnedOnly) {
                Text("Pinned ideas only")
                    .font(.subheadline)
            }
            .toggleStyle(.switch)

            Spacer()

            Button {
                withAnimation(.easeInOut) {
                    highlights.shuffle()
                }
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.body.weight(.semibold))
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.secondary.opacity(0.08))
                    )
            }
            .buttonStyle(.plain)
        }
    }

    private var ideasList: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(filteredIndices, id: \.self) { index in
                DigestIdeaCard(idea: $highlights[index])
            }
        }
    }
}

private struct TagCloud: View {
    let tags: [String]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 12)], spacing: 12) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.accentColor.opacity(0.16))
                    )
                    .foregroundStyle(Color.accentColor)
            }
        }
    }
}

private struct DigestIdeaCard: View {
    @Binding var idea: DigestHighlight

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Text(idea.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                if idea.isPinned {
                    Image(systemName: "pin.fill")
                        .foregroundStyle(idea.accent)
                }
            }

            Text(idea.details)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                Label(idea.category, systemImage: "tag.fill")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(idea.accent.opacity(0.18))
                    )
                    .foregroundStyle(idea.accent)

                Spacer()
            }

            Divider()

            HStack {
                Button {
                    idea.isPinned.toggle()
                } label: {
                    Label(idea.isPinned ? "Unpin" : "Pin", systemImage: idea.isPinned ? "pin.slash.fill" : "pin")
                }
                .buttonStyle(.borderless)

                Spacer()

                Button {
                    idea.isCompleted.toggle()
                } label: {
                    Label(idea.isCompleted ? "Completed" : "Mark as done", systemImage: idea.isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                }
                .buttonStyle(.borderedProminent)
                .tint(idea.accent)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(idea.accent.opacity(0.08))
        )
    }
}
