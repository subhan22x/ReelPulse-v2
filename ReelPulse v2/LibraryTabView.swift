import SwiftUI

struct LibraryTabView: View {
    private enum Filter: String, CaseIterable, Identifiable {
        case all = "All"
        case new = "New"
        case pinned = "Pinned"

        var id: Self { self }
        var title: String { rawValue }
    }

    @State private var filter: Filter = .all
    @State private var videos: [LibraryVideo] = DemoContent.savedVideos
    @State private var projects: [LibraryProject] = DemoContent.projects
    @State private var selectedProject: LibraryProject?
    @State private var isPresentingNewProject = false

    private var filteredVideoIndices: [Int] {
        videos.indices.filter { index in
            switch filter {
            case .all:
                return true
            case .new:
                return videos[index].isNew
            case .pinned:
                return videos[index].isPinned
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    header
                    videosSection
                    projectsSection
                }
                .padding()
            }
            .navigationTitle("Library")
            .sheet(item: $selectedProject) { project in
                ProjectDetailSheet(project: project)
            }
            .sheet(isPresented: $isPresentingNewProject) {
                NewProjectSheet { project in
                    projects.append(project)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your saved clips")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Filter videos, pin favourites, and explore themed projects.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var videosSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center) {
                Text("Recent videos")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Menu {
                    Picker("Filter", selection: $filter) {
                        ForEach(Filter.allCases) { filter in
                            Text(filter.title).tag(filter)
                        }
                    }

                    Divider()

                    Button {
                        sortVideosByNewest()
                    } label: {
                        Label("Sort by newest", systemImage: "clock")
                    }

                    Button {
                        sortVideosAlphabetically()
                    } label: {
                        Label("Sort A–Z", systemImage: "textformat")
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .imageScale(.medium)
                }
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 240), spacing: 16)], spacing: 16) {
                ForEach(filteredVideoIndices, id: \.self) { index in
                    LibraryVideoCard(video: $videos[index])
                }
            }
        }
    }

    private var projectsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Projects")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }

            ForEach(projects) { project in
                LibraryProjectCard(project: project) {
                    selectedProject = project
                }
            }

            Button {
                isPresentingNewProject = true
            } label: {
                Label("Create project", systemImage: "plus.circle.fill")
                    .font(.headline)
            }
            .padding(.top, 4)
        }
    }

    private func sortVideosByNewest() {
        videos.sort { $0.savedAt > $1.savedAt }
    }

    private func sortVideosAlphabetically() {
        videos.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }
}

private struct LibraryVideoCard: View {
    @Binding var video: LibraryVideo

    private static let formatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(video.title)
                        .font(.headline)
                    Text("\(video.source) • \(video.duration)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    video.isPinned.toggle()
                } label: {
                    Image(systemName: video.isPinned ? "bookmark.fill" : "bookmark")
                        .font(.title3)
                        .foregroundStyle(video.isPinned ? Color.accentColor : Color.secondary)
                }
                .buttonStyle(.plain)
            }

            Text(video.category)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(video.accent)

            Label(Self.formatter.localizedString(for: video.savedAt, relativeTo: Date()), systemImage: "clock")
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()

            HStack {
                Button {
                    video.isNew.toggle()
                } label: {
                    Label(video.isNew ? "Mark as seen" : "Mark as new", systemImage: video.isNew ? "eye.fill" : "sparkles")
                }
                .buttonStyle(.borderless)

                Spacer()

                Button {
                    // Placeholder action for demo
                } label: {
                    Text("Open")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .tint(video.accent)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(video.accent.opacity(0.08))
        )
    }
}

private struct LibraryProjectCard: View {
    let project: LibraryProject
    let onOpen: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                Text(project.name)
                    .font(.headline)
                Spacer()
                Text("\(project.clipCount) clips")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(project.color.opacity(0.18))
                    )
                    .foregroundStyle(project.color)
            }

            Text(project.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ProgressView(value: project.progress) {
                Text("Progress")
            }
            .tint(project.color)

            HStack {
                Button {
                    onOpen()
                } label: {
                    Label("Open project", systemImage: "arrow.right")
                }
                .buttonStyle(.borderedProminent)
                .tint(project.color)

                Spacer()

                Button {
                    // Placeholder action
                } label: {
                    Label("Add clip", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                .tint(project.color)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(project.color.opacity(0.08))
        )
    }
}

private struct NewProjectSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var notes: String = ""
    let onCreate: (LibraryProject) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Project name") {
                    TextField("Knitting design ideas", text: $name)
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 140)
                }
            }
            .navigationTitle("New project")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let project = LibraryProject(
                            name: name,
                            summary: notes.isEmpty ? "Organise related clips and notes here." : notes,
                            color: .accentColor,
                            clipCount: 0,
                            progress: 0
                        )
                        onCreate(project)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

private struct ProjectDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let project: LibraryProject

    var body: some View {
        NavigationStack {
            Form {
                Section("Summary") {
                    Text(project.summary)
                }

                Section("Status") {
                    Label("\(project.clipCount) clips linked", systemImage: "film.stack")
                    Label("\(Int(project.progress * 100))% complete", systemImage: "checkmark.circle")
                }

                Section("Next steps") {
                    Text("This is a demo preview. In a future version you'll be able to organise clips, add notes, and generate insights per project.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(project.name)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
