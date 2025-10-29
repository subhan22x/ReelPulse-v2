import Foundation
import SwiftUI

struct OnboardingStep: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let icon: String
    let accent: Color
}

struct ShareDestination: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    let description: String
}

extension ShareDestination {
    static let shareExtension = ShareDestination(
        id: "share-extension",
        name: "Share Extension",
        icon: "square.and.arrow.up",
        color: .accentColor,
        description: "Use the iOS share sheet to send any video link into your library. ReelPulse automatically enriches it with context and transcripts."
    )
}

struct LibraryVideo: Identifiable {
    let id = UUID()
    let title: String
    let source: String
    let category: String
    var isNew: Bool
    var isPinned: Bool
    let accent: Color
    let duration: String
    let savedAt: Date
}

struct LibraryProject: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let summary: String
    let color: Color
    let clipCount: Int
    let progress: Double
}

struct DigestHighlight: Identifiable {
    let id = UUID()
    let title: String
    let details: String
    let category: String
    var isCompleted: Bool
    var isPinned: Bool
    let accent: Color
}

struct ContentCategory: Identifiable {
    let id = UUID()
    let name: String
    let systemImage: String
}

enum DemoContent {
    static let onboarding: [OnboardingStep] = [
        OnboardingStep(
            title: "Collect inspiration instantly",
            message: "Save reels, shorts and TikToks without breaking your flow. ReelPulse grabs the transcript and key points in the background.",
            icon: "sparkles",
            accent: .mint
        ),
        OnboardingStep(
            title: "Organise by project",
            message: "Group clips into themed boards and surface the ones that matter when you need them.",
            icon: "square.grid.2x2.fill",
            accent: .orange
        ),
        OnboardingStep(
            title: "Digest highlights automatically",
            message: "Receive weekly summaries with actionable ideas pulled from the videos you saved.",
            icon: "list.bullet.rectangle.portrait.fill",
            accent: .purple
        ),
        OnboardingStep(
            title: "Stay focused on what inspires you",
            message: "Fine-tune categories, turn on digests and start shaping your personal library of insights.",
            icon: "gearshape.fill",
            accent: .blue
        )
    ]

    static let shareDestinations: [ShareDestination] = [
        ShareDestination(
            id: "instagram",
            name: "Instagram",
            icon: "camera.fill",
            color: .pink,
            description: "Share trending reels directly into ReelPulse and we'll extract the takeaways."
        ),
        ShareDestination(
            id: "tiktok",
            name: "TikTok",
            icon: "music.note",
            color: .purple,
            description: "Send TikTok videos to capture quick creative prompts."
        ),
        ShareDestination(
            id: "youtube",
            name: "YouTube",
            icon: "play.rectangle.fill",
            color: .red,
            description: "Save Shorts without juggling tabs or notes."
        ),
        ShareDestination(
            id: "pinterest",
            name: "Pinterest",
            icon: "pin.fill",
            color: .orange,
            description: "Keep crafty ideas within reach for your next project."
        )
    ]

    static let savedVideos: [LibraryVideo] = [
        LibraryVideo(
            title: "Room Décor Inspiration",
            source: "Instagram",
            category: "Home Furnishing",
            isNew: true,
            isPinned: true,
            accent: .orange,
            duration: "2:14",
            savedAt: Date().addingTimeInterval(-2 * 60)
        ),
        LibraryVideo(
            title: "Yoga Flow Warmup",
            source: "TikTok",
            category: "Wellness",
            isNew: false,
            isPinned: false,
            accent: .green,
            duration: "1:05",
            savedAt: Date().addingTimeInterval(-60 * 60)
        ),
        LibraryVideo(
            title: "Knitting Design Ideas",
            source: "Pinterest",
            category: "Crafts",
            isNew: true,
            isPinned: false,
            accent: .teal,
            duration: "3:20",
            savedAt: Date().addingTimeInterval(-3 * 60 * 60)
        ),
        LibraryVideo(
            title: "Budgeting in Notion",
            source: "YouTube",
            category: "Finance",
            isNew: false,
            isPinned: true,
            accent: .blue,
            duration: "4:45",
            savedAt: Date().addingTimeInterval(-2 * 24 * 60 * 60)
        )
    ]

    static let projects: [LibraryProject] = [
        LibraryProject(
            name: "Room Decor Inspiration",
            summary: "Textures, colour palettes and furniture finds for the living room refresh.",
            color: .orange,
            clipCount: 6,
            progress: 0.45
        ),
        LibraryProject(
            name: "Yoga Exercises",
            summary: "Short flows and stretches for morning energy boosts.",
            color: .green,
            clipCount: 3,
            progress: 0.3
        ),
        LibraryProject(
            name: "Knitting Design Ideas",
            summary: "Patterns, stitches and ideas for the winter collection.",
            color: .teal,
            clipCount: 5,
            progress: 0.6
        )
    ]

    static let digestHighlights: [DigestHighlight] = [
        DigestHighlight(
            title: "Home furnishing: 3 makeover ideas",
            details: "Layer textured throws, swap in warm lighting, and create a capsule decor box to rotate each season.",
            category: "Home",
            isCompleted: false,
            isPinned: true,
            accent: .orange
        ),
        DigestHighlight(
            title: "Finance: automate the essentials",
            details: "Set up a savings waterfall, tag expenses with goals, and keep a 5-minute Friday reconciliation ritual.",
            category: "Finance",
            isCompleted: false,
            isPinned: false,
            accent: .blue
        ),
        DigestHighlight(
            title: "Design: colour stories to try",
            details: "Use a sage and clay palette for calm spaces or punch things up with cobalt and cream.",
            category: "Design",
            isCompleted: false,
            isPinned: false,
            accent: .purple
        ),
        DigestHighlight(
            title: "Journaling: prompts to unblock",
            details: "Sketch the best moment from today, list the conversations you want to revisit, and define tomorrow's focus word.",
            category: "Journaling",
            isCompleted: true,
            isPinned: false,
            accent: .pink
        )
    ]

    static let categories: [ContentCategory] = [
        ContentCategory(name: "Home", systemImage: "house.fill"),
        ContentCategory(name: "Finance", systemImage: "dollarsign.circle.fill"),
        ContentCategory(name: "Design", systemImage: "paintbrush.pointed"),
        ContentCategory(name: "Journaling", systemImage: "pencil.and.outline"),
        ContentCategory(name: "Wellness", systemImage: "heart.fill")
    ]
}
