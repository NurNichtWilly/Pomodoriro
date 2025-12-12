import SwiftUI
import PomodoroEngine

@main
struct PomodoroApp: App {
    @StateObject var timer = PomodoroTimer()
    @StateObject var appState = AppState()

    init() {
        NSApplication.shared.setActivationPolicy(.regular)
    }

    var body: some Scene {
        WindowGroup(id: "timer") {
            ContentView()
                .environmentObject(timer)
                .environmentObject(appState)
        }
        .commands {
            CommandGroup(replacing: .windowSize) {
                Button("Toggle Full Screen") {
                    if let window = NSApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                        window.toggleFullScreen(nil)
                    }
                }
                .keyboardShortcut("f", modifiers: [.command, .control])
            }
        }
        
        MenuBarExtra(content: {
            MenuBarView(timer: timer)
        }, label: {
            if appState.isWindowVisible {
                Image(systemName: "timer")
            } else {
                Text(timeString(from: timer.remainingSeconds) + " (\(timer.mode == .work ? "Work" : "Break"))")
            }
        })
    }
}

struct MenuBarView: View {
    @ObservedObject var timer: PomodoroTimer
    @Environment(\.openWindow) var openWindow

    var body: some View {
        Button("Show Timer") {
            openWindow(id: "timer")
            NSApp.activate(ignoringOtherApps: true)
        }
        Divider()
        Button("Start") { timer.start() }
            .disabled(timer.isRunning)
        Button("Pause") { timer.pause() }
            .disabled(!timer.isRunning)
        Button("Reset") { timer.stop() }
        Divider()
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }
}

extension PomodoroApp {
    // Helper to toggle full screen
    func toggleFullScreen() {
        if let window = NSApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            window.toggleFullScreen(nil)
        }
    }
    
    func timeString(from seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
