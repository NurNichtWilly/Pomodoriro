import SwiftUI
import Combine

public class AppState: ObservableObject {
    @Published public var isWindowVisible: Bool = true
    @Published public var isAlwaysOnTop: Bool = false
    @AppStorage("viewStyle") public var viewStyle: ViewStyle = .immersive
    @AppStorage("isDNDEnabled") public var isDNDEnabled: Bool = false
    
    public init() {}
}

public enum ViewStyle: String, CaseIterable, Identifiable {
    case classic
    case immersive
    
    public var id: String { self.rawValue }
    public var displayName: String {
        switch self {
        case .classic: return "Classic"
        case .immersive: return "Immersive"
        }
    }
}
