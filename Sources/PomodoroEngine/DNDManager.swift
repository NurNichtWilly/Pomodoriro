import Foundation
import Combine

@MainActor
public class DNDManager {
    public init() {}
    
    public func shouldEnableDND(timer: PomodoroTimer, appState: AppState) -> Bool {
        guard appState.isDNDEnabled else { return false }
        return timer.isRunning && timer.mode == .work
    }
    
    public func updateDND(timer: PomodoroTimer, appState: AppState, runner: ShortcutRunner) {
        guard appState.isDNDEnabled else { return }
        let shouldBeActive = shouldEnableDND(timer: timer, appState: appState)
        let shortcutName = shouldBeActive ? "Pomodoro Focus On" : "Pomodoro Focus Off"
        runner.runShortcut(named: shortcutName)
    }
}

public protocol ShortcutRunner {
    func runShortcut(named name: String)
}

public struct ProcessShortcutRunner: ShortcutRunner {
    public init() {}
    public func runShortcut(named name: String) {
        // Run in background to avoid blocking the main thread
        Task.detached(priority: .userInitiated) {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/shortcuts")
            process.arguments = ["run", name]
            
            let pipe = Pipe()
            process.standardError = pipe
            
            do {
                try process.run()
                process.waitUntilExit()
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let errorOutput = String(data: data, encoding: .utf8), !errorOutput.isEmpty {
                    if errorOutput.contains("Couldn’t find shortcut") {
                        print("⚠️ [DND] Shortcut '\(name)' missing. Please create it in the Shortcuts app.")
                    } else {
                        print("⚠️ [DND] Error running shortcut: \(errorOutput.trimmingCharacters(in: .whitespacesAndNewlines))")
                    }
                }
            } catch {
                print("⚠️ [DND] Failed to launch shortcuts command: \(error)")
            }
        }
    }
}
