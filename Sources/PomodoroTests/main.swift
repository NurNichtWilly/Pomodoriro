import Foundation
import PomodoroEngine

func assert(_ condition: Bool, _ message: String) {
    if !condition {
        print("❌ FAIL: \(message)")
        exit(1)
    } else {
        print("✅ PASS: \(message)")
    }
}

// Helper to allow async tick propagation
func runLoop() async {
    try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
}

@MainActor
func runTests() async {
    print("Running Tests...")

    // Test: Initialization
    let timer = PomodoroTimer()
assert(timer.remainingSeconds == 1500, "Initialization defaults to 1500 seconds")
assert(timer.isRunning == false, "Initially not running")

// Test: Start
timer.start()
assert(timer.isRunning == true, "Starts running")

// Test: Pause
timer.pause()
assert(timer.isRunning == false, "Pauses running")

// Test: Stop
timer.start()
timer.stop()
assert(timer.isRunning == false, "Stops running")
assert(timer.remainingSeconds == 1500, "Resets to 1500 seconds after stop")

// Test: Tick
timer.start()
timer.tick()
await runLoop()
assert(timer.remainingSeconds == 1499, "Decrements by 1 second when running")

timer.pause()
timer.tick()
await runLoop()
assert(timer.remainingSeconds == 1499, "Does not decrement when paused")

// Test: Completion (Boundary)
timer.remainingSeconds = 1
timer.start()
timer.tick()
await runLoop()
assert(timer.remainingSeconds == 0, "Decrements to 0")
timer.tick()
await runLoop()
assert(timer.remainingSeconds == 0, "Stops at 0")

// Test: Callback
timer.remainingSeconds = 1
var callbackCalled = false
timer.onTimerComplete = {
    callbackCalled = true
}
timer.start()
timer.tick()
await runLoop()
assert(callbackCalled == true, "Callback called on completion")
assert(timer.isRunning == false, "Stops running on completion")

// Test: Session Management
// Default mode check (implicit)
// Test: Switch to Short Break
timer.switchMode(.shortBreak)
assert(timer.remainingSeconds == 300, "Short break duration is 300")
// Test: Switch to Long Break
timer.switchMode(.longBreak)
assert(timer.remainingSeconds == 900, "Long break duration is 900")
// Test: Switch Mode Stops Timer
timer.start()
timer.switchMode(.work)
assert(timer.remainingSeconds == 1500, "Reset to work duration")
assert(timer.remainingSeconds == 1500, "Reset to work duration")
assert(timer.isRunning == false, "Stops running on mode switch")

// Test: Session Counting
timer.completedSessions = 0
timer.switchMode(.work)
timer.remainingSeconds = 1
timer.start()
timer.tick()
await runLoop()
assert(timer.completedSessions == 1, "Increments session on work completion")

// Test: Break does not increment
timer.switchMode(.shortBreak)
timer.remainingSeconds = 1
timer.start()
timer.tick()
await runLoop()
assert(timer.completedSessions == 1, "Does not increment on break completion")

    // Test: Custom Durations
    timer.workDuration = 60
    timer.switchMode(.work)
    assert(timer.remainingSeconds == 60, "Updates to custom work duration")

    timer.shortBreakDuration = 10
    timer.switchMode(.shortBreak)
    assert(timer.remainingSeconds == 10, "Updates to custom short break duration")

    timer.longBreakDuration = 20
    timer.switchMode(.longBreak)
    assert(timer.remainingSeconds == 20, "Updates to custom long break duration")

    // Test: Tick (Async)
    timer.workDuration = 100
    timer.switchMode(.work) // Reset
    timer.start()
    timer.tick() // This schedules a Task
    await runLoop() // Wait for Task
    assert(timer.remainingSeconds == 99, "Decrements by 1 second when running (Async)")

    print("All tests passed!")
}

// Run the tests
Task {
    await runTests()
    exit(0)
}

RunLoop.main.run()
