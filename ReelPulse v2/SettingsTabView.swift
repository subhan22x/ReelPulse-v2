import SwiftUI

struct SettingsTabView: View {
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
