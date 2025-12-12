import SwiftUI
import PomodoroEngine

struct SettingsView: View {
    @EnvironmentObject var timer: PomodoroTimer
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.headline)
            
            Toggle("Always on Top", isOn: $appState.isAlwaysOnTop)
            
            GroupBox(label: Text("Durations (minutes)")) {
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 10) {
                    GridRow {
                        Text("Work")
                            .gridColumnAlignment(.trailing)
                        TextField("25", value: Binding(
                            get: { timer.workDuration / 60 },
                            set: { timer.workDuration = $0 * 60 }
                        ), format: .number)
                        .frame(width: 60)
                        Text("min")
                            .foregroundColor(.secondary)
                    }

                    GridRow {
                        Text("Short Break")
                            .gridColumnAlignment(.trailing)
                        TextField("5", value: Binding(
                            get: { timer.shortBreakDuration / 60 },
                            set: { timer.shortBreakDuration = $0 * 60 }
                        ), format: .number)
                        .frame(width: 60)
                        Text("min")
                            .foregroundColor(.secondary)
                    }

                    GridRow {
                        Text("Long Break")
                            .gridColumnAlignment(.trailing)
                        TextField("15", value: Binding(
                            get: { timer.longBreakDuration / 60 },
                            set: { timer.longBreakDuration = $0 * 60 }
                        ), format: .number)
                        .frame(width: 60)
                        Text("min")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            
            Text("Changes apply to the next timer session.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .frame(width: 350)
    }
}
