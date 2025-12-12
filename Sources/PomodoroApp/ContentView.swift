import SwiftUI
import PomodoroEngine

struct ContentView: View {
    @EnvironmentObject var timer: PomodoroTimer
    @EnvironmentObject var appState: AppState
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 20) {
            // Mode Picker
            Picker("Mode", selection: Binding(
                get: { timer.mode },
                set: { timer.switchMode($0) }
            )) {
                Text("Work").tag(PomodoroTimer.Mode.work)
                Text("Short Break").tag(PomodoroTimer.Mode.shortBreak)
                Text("Long Break").tag(PomodoroTimer.Mode.longBreak)
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            // Timer Display
            Text(timeString(from: timer.remainingSeconds))
                .font(.system(size: 200, weight: .bold, design: .monospaced))
                .minimumScaleFactor(0.1)
                .lineLimit(1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            
            // Session Counter
            Text("Sessions Completed: \(timer.completedSessions)")
                .font(.caption)
                .foregroundColor(.secondary)

            // Controls
            HStack(spacing: 15) {
                Button(action: {
                    if timer.isRunning {
                        timer.pause()
                    } else {
                        timer.start()
                    }
                }) {
                    Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                Button(action: {
                    timer.stop()
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding()
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
        }
        .padding(30)
        .frame(minWidth: 350, minHeight: 250)
        .background(WindowAccessor(appState: appState))
        .onAppear {
             appState.isWindowVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { notification in
            if let window = notification.object as? NSWindow, window.isKeyWindow {
                appState.isWindowVisible = false
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gear")
                }
            }
        }
        .sheet(isPresented: $showSettings) {
             SettingsView()
                 .environmentObject(appState)
        }
    }

    func timeString(from seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
