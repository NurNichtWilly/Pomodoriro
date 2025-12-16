import SwiftUI
import PomodoroEngine

struct WindowAccessor: NSViewRepresentable {
    @ObservedObject var appState: AppState
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                window.collectionBehavior.insert(.fullScreenPrimary)
                window.collectionBehavior.insert(.managed)
                window.title = "Pomodoriro"
                window.styleMask.insert(.resizable)
                updateWindowLevel(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            if let window = nsView.window {
                updateWindowLevel(window)
            }
        }
    }
    
    private func updateWindowLevel(_ window: NSWindow) {
        window.level = appState.isAlwaysOnTop ? .floating : .normal
    }
}
