// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pomodoriro",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Pomodoriro", targets: ["PomodoroApp"]),
        .library(name: "PomodoroEngine", targets: ["PomodoroEngine"]),
    ],
    targets: [
        // Core Logic
        .target(
            name: "PomodoroEngine",
            dependencies: []
        ),
        // UI / Executable
        .executableTarget(
            name: "PomodoroApp",
            dependencies: ["PomodoroEngine"]
        ),
        // Manual Tests (Bypassing XCTest)
        .executableTarget(
            name: "PomodoroTests",
            dependencies: ["PomodoroEngine"]
        ),
    ]
)
