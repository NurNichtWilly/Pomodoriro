import Foundation
import Combine
import Analytics

@MainActor
public class PomodoroTimer: ObservableObject {
    public enum Mode {
        case work
        case shortBreak
        case longBreak
    }

    @Published public var remainingSeconds: Int
    @Published public var isRunning: Bool
    @Published public var mode: Mode
    @Published public var completedSessions: Int
    
    @Published public var workDuration: Int
    @Published public var shortBreakDuration: Int
    @Published public var longBreakDuration: Int

    public var onTimerComplete: (() -> Void)?

    /// Optional analytics sink. Inject in the App for telemetry.
    public var analytics: Analytics?

    public init() {
        self.mode = .work
        self.workDuration = 1500
        self.shortBreakDuration = 300
        self.longBreakDuration = 900
        self.remainingSeconds = 1500
        self.isRunning = false
        self.completedSessions = 0
    }

    public func switchMode(_ mode: Mode) {
        self.mode = mode
        self.isRunning = false
        self.internalTimer?.invalidate()
        self.internalTimer = nil
        switch mode {
        case .work:
            self.remainingSeconds = workDuration
        case .shortBreak:
            self.remainingSeconds = shortBreakDuration
        case .longBreak:
            self.remainingSeconds = longBreakDuration
        }
        analytics?.trackEvent("mode_switched", properties: ["mode": "\(mode)"])
    }

    private var internalTimer: Timer?

    public func start() {
        self.isRunning = true
        self.internalTimer?.invalidate()
        self.internalTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        analytics?.trackEvent("timer_start", properties: ["mode": "\(mode)"])
    }

    public func pause() {
        self.isRunning = false
        self.internalTimer?.invalidate()
        self.internalTimer = nil
        analytics?.trackEvent("timer_pause", properties: ["mode": "\(mode)"])
    }

    public func stop() {
        self.isRunning = false
        self.internalTimer?.invalidate()
        self.internalTimer = nil
        // Reset to initial duration based on mode
        switch mode {
        case .work:
            self.remainingSeconds = workDuration
        case .shortBreak:
            self.remainingSeconds = shortBreakDuration
        case .longBreak:
            self.remainingSeconds = longBreakDuration
        }
        analytics?.trackEvent("timer_stop", properties: ["mode": "\(mode)"])
    }

    nonisolated public func tick() {
        Task { @MainActor in
            if isRunning && remainingSeconds > 0 {
                remainingSeconds -= 1
                if remainingSeconds == 0 {
                    if mode == .work {
                        completedSessions += 1
                        analytics?.trackEvent("session_completed", properties: ["completedSessions": "\(completedSessions)"])
                    }
                    analytics?.trackEvent("timer_complete", properties: ["mode": "\(mode)"])
                    isRunning = false
                    internalTimer?.invalidate()
                    internalTimer = nil
                    onTimerComplete?()
                }
            }
        }
    }
}
