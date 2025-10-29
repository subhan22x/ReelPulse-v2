import SwiftUI

struct ContentView: View {
    @State private var hasCompletedOnboarding = false

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                RootTabView {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        hasCompletedOnboarding = false
                    }
                }
            } else {
                OnboardingFlowView {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        hasCompletedOnboarding = true
                    }
                }
            }
        }
        .transition(.opacity.combined(with: .scale))
    }
}

private struct RootTabView: View {
    enum Tab: Hashable { case capture, library, digest, settings }

    @State private var selection: Tab = .capture
    let onResetOnboarding: () -> Void

    var body: some View {
        TabView(selection: $selection) {
            CaptureView()
                .tabItem {
                    Label("Capture", systemImage: "sparkles")
                }
                .tag(Tab.capture)

            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "rectangle.stack.fill")
                }
                .tag(Tab.library)

            DigestView()
                .tabItem {
                    Label("Digest", systemImage: "list.bullet.rectangle")
                }
                .tag(Tab.digest)

            SettingsView(onResetOnboarding: onResetOnboarding)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(Tab.settings)
        }
    }
}

private struct OnboardingFlowView: View {
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

private struct CaptureView: View {
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

            Text("We found three actionable steps, the supply list, and tagged this clip under "Crafts" for you.")
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

private struct LibraryView: View {
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
                    filterHeader
                    videosSection
                    projectsSection
                }
                .padding()
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresentingNewProject = true
                    } label: {
                        Label("New project", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewProject) {
                NewProjectSheet { project in
                    projects.insert(project, at: 0)
                }
            }
            .sheet(item: $selectedProject) { project in
                ProjectDetailSheet(project: project)
            }
        }
    }

    private var filterHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Saved videos")
                .font(.title2)
                .fontWeight(.bold)
            Text("Browse the clips you've captured and keep your favourites pinned for quick access.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Picker("Filter", selection: $filter) {
                ForEach(Filter.allCases) { filter in
                    Text(filter.title).tag(filter)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var videosSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(filter == .all ? "All videos" : filter == .new ? "New arrivals" : "Pinned videos")
                    .font(.headline)
                Spacer()
                Menu {
                    Button {
                        sortVideosByNewest()
                    } label: {
                        Label("Sort by newest", systemImage: "clock.arrow.circlepath")
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

private struct DigestView: View {
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

private struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var digestDay: DigestDay = .friday
    @State private var categories: [ContentCategory] = DemoContent.categories
    @State private var selectedCategoryIDs: Set<UUID> = Set(DemoContent.categories.map(\.id))
    @State private var showCategorySheet = false

    let onResetOnboarding: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Notifications") {
                    Toggle("Weekly digest", isOn: $notificationsEnabled)
                    Picker("Digest day", selection: $digestDay) {
                        ForEach(DigestDay.allCases) { day in
                            Text(day.title).tag(day)
                        }
                    }
                }

                Section("Favourite content categories") {
                    CategoryGrid(categories: categories, selectedCategoryIDs: $selectedCategoryIDs)
                    Button {
                        showCategorySheet = true
                    } label: {
                        Label("Add category", systemImage: "plus.circle")
                    }
                }

                Section("Data") {
                    Button {
                        // placeholder for export action
                    } label: {
                        Label("Export saved insights", systemImage: "square.and.arrow.up")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        onResetOnboarding()
                    } label: {
                        Text("Restart onboarding")
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showCategorySheet) {
                NewCategorySheet { name, symbol in
                    let newCategory = ContentCategory(name: name, systemImage: symbol)
                    categories.append(newCategory)
                    selectedCategoryIDs.insert(newCategory.id)
                }
            }
        }
    }
}

private enum DigestDay: String, CaseIterable, Identifiable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday

    var id: Self { self }

    var title: String {
        rawValue.capitalized
    }
}

private struct CategoryGrid: View {
    let categories: [ContentCategory]
    @Binding var selectedCategoryIDs: Set<UUID>

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 140), spacing: 12)]
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(categories) { category in
                let isSelected = selectedCategoryIDs.contains(category.id)
                Button {
                    if isSelected {
                        selectedCategoryIDs.remove(category.id)
                    } else {
                        selectedCategoryIDs.insert(category.id)
                    }
                } label: {
                    HStack {
                        Image(systemName: category.systemImage)
                        Text(category.name)
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(isSelected ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.08))
                    )
                    .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct NewCategorySheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var symbol: String = "tag"
    let onCreate: (String, String) -> Void

    private let suggestions = ["tag", "sparkles", "paintpalette.fill", "flame.fill", "leaf.fill"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Category name", text: $name)
                }

                Section("Icon") {
                    TextField("SF Symbol", text: $symbol)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(suggestions, id: \.self) { suggestion in
                                Button {
                                    symbol = suggestion
                                } label: {
                                    Image(systemName: suggestion)
                                        .font(.title3)
                                        .frame(width: 48, height: 48)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .fill(symbol == suggestion ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.08))
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("New category")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        onCreate(trimmedName.isEmpty ? "Untitled" : trimmedName,
                                 symbol.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "tag" : symbol)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
