import ScreenSaver
import AppKit
import MetalKit

var device: MTLDevice!
var commandQueue: MTLCommandQueue!
var metalPipelineState: MTLRenderPipelineState!
var vertexBuffer: MTLBuffer?


struct Blade {
    var base: CGPoint
    var tip: CGPoint
}

struct Wind {
    var direction: CGPoint
    var magnitude: CGFloat
}

class GrassScreenSaverView: ScreenSaverView {
    
    var grassBlades: [Blade] = []
    
    var wind = Wind(direction: CGPoint(x: 1, y: 0), magnitude: 2.0)
    
    let bladeWidth: CGFloat = 1.0
    let bladeHeight: CGFloat = 6.0
    let bladeSpacing: CGFloat = 5.0
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        animationTimeInterval = 1.0 / 30.0
        
        setupBlades()
        
        print("GrassScreenSaverView initialized with frame: \(frame)")
        print("Total blades: \(grassBlades.count)")
    }
    
    func setupBlades() {
        guard grassBlades.isEmpty else { return }

        let columns = Int(self.bounds.width / (bladeWidth + bladeSpacing))
        let rows = Int(self.bounds.height / (bladeHeight + bladeSpacing))
        
        for _ in 0..<(rows * columns) {
            // Increased random offsets
            let offsetX = CGFloat.random(in: -3...3)
            let offsetY = CGFloat.random(in: -6...6)
            
            let baseX = CGFloat.random(in: 0..<self.bounds.width)
            let baseY = CGFloat.random(in: 0..<self.bounds.height)
            let base = CGPoint(x: baseX + offsetX, y: baseY + offsetY)
            let tip = CGPoint(x: baseX + offsetX, y: baseY + offsetY + bladeHeight)
            grassBlades.append(Blade(base: base, tip: tip))
        }
    }


    
    override func draw(_ rect: NSRect) {
        // Set the background color to dark green
        NSColor(red: 0.0, green: 0.2, blue: 0.0, alpha: 1.0).setFill()
        NSBezierPath(rect: rect).fill()
        
        NSColor.green.set()
        for blade in grassBlades {
            let path = NSBezierPath()
            path.move(to: blade.base)
            let adjustedTip = CGPoint(x: blade.tip.x + wind.direction.x * wind.magnitude,
                                      y: blade.tip.y + wind.direction.y * wind.magnitude)
            path.line(to: adjustedTip)
            path.lineWidth = bladeWidth
            path.stroke()
        }
    }


    override func animateOneFrame() {
        adjustWind()
        setNeedsDisplay(bounds)
    }
    
    func adjustWind() {
        // Randomly adjust the wind's direction and magnitude for variation
        let randomAngle = CGFloat.random(in: -0.05...0.05)
        let randomMagnitude = CGFloat.random(in: -0.5...0.5)
        
        let dx = cos(randomAngle) * wind.direction.x - sin(randomAngle) * wind.direction.y
        let dy = sin(randomAngle) * wind.direction.x + cos(randomAngle) * wind.direction.y
        
        wind.direction = CGPoint(x: dx, y: dy)
        wind.magnitude += randomMagnitude
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
}
