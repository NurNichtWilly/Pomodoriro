import SwiftUI

struct TimerArcView: View {
    var progress: Double
    var color: Color = .blue
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Track
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(color)
                
                // Progress Arc
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: progress)
            }
        }
    }
}

struct TimerArcView_Previews: PreviewProvider {
    static var previews: some View {
        TimerArcView(progress: 0.7)
            .frame(width: 200, height: 200)
            .padding()
    }
}
