import SwiftUI
import PomodoroEngine

struct ContentView: View {
    @EnvironmentObject var timer: PomodoroTimer
    @EnvironmentObject var appState: AppState
    @State private var showSettings = false

    var body: some View {
        ZStack {
            // Background Layer
            Color(NSColor.windowBackgroundColor)
                .ignoresSafeArea()
            
            // Particle Effects
            ParticleEffectView()
                .opacity(0.5)
                .ignoresSafeArea()
            
            // Main Content
            VStack {
                // Mode Picker (Top)
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
                .padding(.top, 20)
                .frame(maxWidth: 300)
                
                Spacer()
                
                // Timer Visualization
                ZStack {
                    TimerArcView(
                        progress: calculateProgress(),
                        color: modeColor(for: timer.mode)
                    )
                    .padding(40)
                    
                    Text(timeString(from: timer.remainingSeconds))
                        .font(.system(size: 120, weight: .thin, design: .monospaced))
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                        .padding(60)
                }
                .aspectRatio(1, contentMode: .fit)
                .frame(maxHeight: .infinity)
                
                Spacer()
                
                // Controls (Bottom)
                HStack(spacing: 30) {
                    Button(action: {
                        if timer.isRunning {
                            timer.pause()
                        } else {
                            timer.start()
                        }
                    }) {
                        Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .padding()
                    }
                    .buttonStyle(.plain)
                    .background(Circle().fill(modeColor(for: timer.mode).opacity(0.2)))
                    .overlay(Circle().stroke(modeColor(for: timer.mode), lineWidth: 2))
                    
                    Button(action: {
                        timer.stop()
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding()
                    }
                    .buttonStyle(.plain)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                }
                .padding(.bottom, 30)
            }
            .padding()
        }
        .frame(minWidth: 500, minHeight: 400)
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
    
    func calculateProgress() -> Double {
        let total: Double
        switch timer.mode {
        case .work:
            total = Double(timer.workDuration)
        case .shortBreak:
            total = Double(timer.shortBreakDuration)
        case .longBreak:
            total = Double(timer.longBreakDuration)
        }
        
        let safeTotal = max(total, 1.0)
        let remaining = Double(timer.remainingSeconds)
        return remaining / safeTotal
    }
    
    func modeColor(for mode: PomodoroTimer.Mode) -> Color {
        switch mode {
        case .work: return .blue
        case .shortBreak: return .green
        case .longBreak: return .orange
        }
    }
}
