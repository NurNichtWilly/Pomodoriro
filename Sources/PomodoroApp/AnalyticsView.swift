import SwiftUI
import Analytics

struct AnalyticsView: View {
    @ObservedObject private var center = AnalyticsCenter.shared

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Analytics Events")
                    .font(.headline)
                Spacer()
                Button("Clear") {
                    center.clear()
                }
                .keyboardShortcut("k", modifiers: [.command, .shift])
            }
            .padding()

            List(center.events) { event in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(event.name)
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        Text(event.date, style: .time)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    if let props = event.properties, !props.isEmpty {
                        Text(props.map { "\($0)=\($1)" }.joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 6)
            }
        }
        .frame(minWidth: 450, minHeight: 300)
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
