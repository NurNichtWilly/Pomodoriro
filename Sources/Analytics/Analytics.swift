import Foundation
import Combine
import SwiftUI

public struct AnalyticsEvent: Identifiable {
    public let id: UUID
    public let name: String
    public let properties: [String: String]?
    public let date: Date

    public init(id: UUID = UUID(), name: String, properties: [String: String]?, date: Date = Date()) {
        self.id = id
        self.name = name
        self.properties = properties
        self.date = date
    }
}

@MainActor
public final class AnalyticsCenter: ObservableObject {
    public static let shared = AnalyticsCenter()

    @Published public private(set) var events: [AnalyticsEvent] = []

    public func record(event name: String, properties: [String: String]?) {
        let ev = AnalyticsEvent(name: name, properties: properties)
        events.insert(ev, at: 0)
    }

    public func clear() {
        events.removeAll()
    }

    private init() {}
}

public protocol Analytics {
    /// Track a named event with optional properties
    func trackEvent(_ name: String, properties: [String: String]?)
}

/// A simple console analytics implementation for development and local debugging.
public final class ConsoleAnalytics: Analytics {
    public init() {}

    public func trackEvent(_ name: String, properties: [String: String]?) {
        var line = "[Analytics] Event: \(name)"
        if let props = properties, !props.isEmpty {
            let propsStr = props.map { "\($0)=\($1)" }.joined(separator: ",")
            line += " (\(propsStr))"
        }
        print(line)
        // Also publish to the shared AnalyticsCenter for the UI
        Task { @MainActor in
            AnalyticsCenter.shared.record(event: name, properties: properties)
        }
    }
}
