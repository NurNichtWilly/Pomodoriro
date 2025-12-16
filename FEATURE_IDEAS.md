# Feature Ideas for Pomodoriro

## 1. Sound Effects & Notifications (High Priority)
Currently, the timer silently stops when it hits zero.
*   **Sound Effects:** Play a chime or bell when a session ends.
*   **System Notifications:** Send a macOS User Notification (banner) so the user knows the timer finished even if the app is in the background.

## 2. Task Management
Right now, the timer is "generic." Adding a simple **Task List** would allow users to:
*   Create a list of to-dos.
*   Select an "active task" to track time against specific work items.
*   See how many "Pomodoros" each task took.

## 3. Data Persistence
The `Analytics` module appears to be in-memory only. If the user quits the app, their history is lost.
*   **Persistence:** Save completed sessions to `UserDefaults` or a JSON file (or SwiftData) so users can see their daily/weekly progress over time.

## 4. "Do Not Disturb" Integration
To truly help with focus, the app could:
*   Automatically enable macOS **Focus Mode / Do Not Disturb** when a "Work" session starts.
*   Disable it automatically when the break starts.

## 5. Global Keyboard Shortcuts
Power users love controlling timers without bringing the app to the front.
*   Add global hotkeys (e.g., `Cmd+Shift+P`) to Start/Pause the timer from anywhere in macOS.

## 6. Continuous Mode (Auto-start)
*   Add a setting to automatically start the next timer (e.g., Break starts automatically after Work ends, or vice versa) for a smoother flow.
