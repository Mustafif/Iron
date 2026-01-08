import Combine
import SwiftUI

public struct ContentView: View {
    @EnvironmentObject var ironApp: IronApp
    @StateObject private var navigationModel = NavigationModel()
    @StateObject private var themeManager = ThemeManager()

    public init() {}

    public var body: some View {
        NavigationSplitView(columnVisibility: $navigationModel.sidebarVisibility) {
            SidebarView()
                .environmentObject(navigationModel)
                .environmentObject(themeManager)
        } detail: {
            DetailView()
                .environmentObject(navigationModel)
                .environmentObject(themeManager)
        }
        .navigationSplitViewStyle(.balanced)
        .themedAccent(themeManager)
        .themedBackground(themeManager)
        .preferredColorScheme(themeManager.currentTheme.isDark ? .dark : .light)
        .onAppear {
            Task {
                await initializeApp()
            }
        }
        .alert("Error", isPresented: $navigationModel.showingError) {
            Button("OK") {
                navigationModel.currentError = nil
            }
        } message: {
            if let error = navigationModel.currentError {
                Text(error.localizedDescription)
            }
        }
        .sheet(isPresented: $navigationModel.showingNoteCreation) {
            NoteCreationSheet()
                .environmentObject(ironApp)
                .environmentObject(navigationModel)
                .environmentObject(themeManager)
        }

        .sheet(isPresented: $navigationModel.showingFolderCreation) {
            FolderCreationView()
                .environmentObject(ironApp)
                .environmentObject(navigationModel)
                .environmentObject(themeManager)
        }
        .sheet(isPresented: $navigationModel.showingRenameNote) {
            if let note = navigationModel.noteForAction {
                RenameNoteDialog(note: note)
                    .environmentObject(ironApp)
                    .environmentObject(navigationModel)
                    .environmentObject(themeManager)
            }
        }
        .sheet(isPresented: $navigationModel.showingMoveNote) {
            if let note = navigationModel.noteForAction {
                MoveNoteDialog(note: note)
                    .environmentObject(ironApp)
                    .environmentObject(navigationModel)
                    .environmentObject(themeManager)
            }
        }
        .sheet(isPresented: $navigationModel.showingRenameFolder) {
            if let folder = navigationModel.folderForAction {
                RenameFolderDialog(folder: folder)
                    .environmentObject(ironApp)
                    .environmentObject(navigationModel)
                    .environmentObject(themeManager)
            }
        }
        .onChange(of: navigationModel.showingFolderCreation) { _, newValue in
            print("ContentView: showingFolderCreation changed to: \(newValue)")
        }
    }

    private func initializeApp() async {
        // Use ~/.iron as the single storage location
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        let ironDirectory = homeDirectory.appendingPathComponent(".iron")
        let notesDirectory = ironDirectory.appendingPathComponent("notes")

        do {
            // Create ~/.iron directory structure
            try FileManager.default.createDirectory(
                at: ironDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )

            try FileManager.default.createDirectory(
                at: notesDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )

            // Create welcome note if this is first run
            let welcomeNotePath = notesDirectory.appendingPathComponent("Welcome.md")
            if !FileManager.default.fileExists(atPath: welcomeNotePath.path) {
                try createWelcomeNote(at: welcomeNotePath)
            }

            // Initialize Iron with the notes directory
            try await ironApp.initialize(vaultPath: notesDirectory.path)

        } catch {
            await MainActor.run {
                navigationModel.currentError = error
                navigationModel.showingError = true
            }
        }
    }

    private func createWelcomeNote(at url: URL) throws {
        let welcomeContent = """
            # Welcome to Iron!

            This is your Iron knowledge management system. Your notes are stored in `~/.iron/notes/`.

            ## Getting Started

            - Create and organize your notes
            - Use markdown formatting for rich text
            - Link between notes using [[Note Name]] syntax
            - Search across all your content

            ## Features

            - **Markdown Editor**: Full markdown support with live preview
            - **Note Linking**: Create connections between your ideas
            - **Search**: Find anything across your notes
            - **File Organization**: Organize notes in folders

            ## Tips

            1. Start by creating a few notes on topics that interest you
            2. Use the search feature to quickly find content
            3. Link related notes together to build your knowledge graph

            Happy note-taking! 📝

            ---
            *Created on \(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short))*
            """

        try welcomeContent.write(to: url, atomically: true, encoding: .utf8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(IronApp())
                .previewDisplayName("Ghost White")

            ContentView()
                .environmentObject(IronApp())
                .onAppear {
                    let themeManager = ThemeManager()
                    themeManager.setTheme(.tokyoNight)
                }
                .previewDisplayName("Tokyo Night")

            ContentView()
                .environmentObject(IronApp())
                .onAppear {
                    let themeManager = ThemeManager()
                    themeManager.setTheme(.catppuccinMocha)
                }
                .previewDisplayName("Catppuccin Mocha")
        }
    }

}
