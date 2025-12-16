import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isWindowVisible: Bool = true
    @Published var isAlwaysOnTop: Bool = false
    @AppStorage("viewStyle") var viewStyle: ViewStyle = .immersive
    @AppStorage("isDNDEnabled") var isDNDEnabled: Bool = false
}

enum ViewStyle: String, CaseIterable, Identifiable {
    case classic
    case immersive
    
    var id: String { self.rawValue }
    var displayName: String {
        switch self {
        case .classic: return "Classic"
        case .immersive: return "Immersive"
        }
    }
}
