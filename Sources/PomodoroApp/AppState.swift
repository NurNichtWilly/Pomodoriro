import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isWindowVisible: Bool = true
    @Published var isAlwaysOnTop: Bool = false
}
