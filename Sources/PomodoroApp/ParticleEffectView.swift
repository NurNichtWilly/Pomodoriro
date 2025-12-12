import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var scale: CGFloat
    var opacity: Double
    var speed: Double
}

struct ParticleEffectView: View {
    @State private var particles: [Particle] = []
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(Color.white)
                        .scaleEffect(particle.scale)
                        .opacity(particle.opacity)
                        .position(x: particle.x, y: particle.y)
                }
            }
            .onReceive(timer) { _ in
                updateParticles(in: geometry.size)
            }
            .onAppear {
                // Initialize with some particles
                for _ in 0..<20 {
                    addParticle(in: geometry.size)
                }
            }
        }
        .background(Color.clear)
        .blur(radius: 2)
    }
    
    func addParticle(in size: CGSize) {
        let particle = Particle(
            x: CGFloat.random(in: 0...size.width),
            y: size.height + CGFloat.random(in: 0...100), // Start below screen or random vertical for init
            scale: CGFloat.random(in: 0.2...0.8),
            opacity: Double.random(in: 0.1...0.5),
            speed: Double.random(in: 1...3)
        )
        particles.append(particle)
    }
    
    func updateParticles(in size: CGSize) {
        // Move particles up
        for i in indices(particles) {
            particles[i].y -= particles[i].speed
        }
        
        // Remove particles that are off screen
        particles.removeAll { $0.y < -50 }
        
        // Add new particles to replace removed ones
        while particles.count < 20 {
            let particle = Particle(
                x: CGFloat.random(in: 0...size.width),
                y: size.height + 50,
                scale: CGFloat.random(in: 0.2...0.8),
                opacity: Double.random(in: 0.1...0.5),
                speed: Double.random(in: 1...3)
            )
            particles.append(particle)
        }
    }
    
    // Safety helper for indices
    func indices(_ particles: [Particle]) -> Range<Int> {
        return 0..<particles.count
    }
}
