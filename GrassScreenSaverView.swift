import ScreenSaver
import Cocoa

class GrassScreenSaverView: ScreenSaverView {
    
    var circle: CircleView!
    var circle2: CircleView!
    var circleVelocity: CGPoint = CGPoint(x: 2.0, y: 2.0)
    var circle2Velocity: CGPoint = CGPoint(x: 2.0, y: 2.0)
    var logoImageView: NSImageView!
    var colorArray: [NSColor] = [
        NSColor(calibratedRed: 234.0/255.0, green: 61.0/255.0, blue: 37.0/255.0, alpha: 1.0), // Red
        NSColor(calibratedRed: 234.0/255.0, green: 254.0/255.0, blue: 83.0/255.0, alpha: 1.0), // Yellow
        NSColor(calibratedRed: 106.0/255.0, green: 230.0/255.0, blue: 69.0/255.0, alpha: 1.0), // Green
        NSColor(calibratedRed: 98.0/255.0, green: 16.0/255.0, blue: 245.0/255.0, alpha: 1.0),  // Purple
        NSColor(calibratedRed: 11.0/255.0, green: 36.0/255.0, blue: 245.0/255.0, alpha: 1.0)   // Blue
    ]

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        self.animationTimeInterval = 1.0 / 30.0
        setupCircles()
        setupLogo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCircles() {
        circle = CircleView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), color: colorArray.randomElement() ?? .red)
        circle2 = CircleView(frame: CGRect(x: 50, y: 50, width: 100, height: 100), color: colorArray.randomElement() ?? .green)
        self.addSubview(circle)
        self.addSubview(circle2)
    }
    
    func setupLogo() {
        let bundle = Bundle(for: type(of: self))
        guard let logoImage = bundle.image(forResource: "logo.png") else {
            print("Failed to load logo.png from screensaver bundle")
            return
        }
        
        let aspectRatio = logoImage.size.height / logoImage.size.width
        let logoWidth: CGFloat = 500 // Desired width for the logo
        let logoHeight: CGFloat = logoWidth * aspectRatio
        
        logoImageView = NSImageView(frame: CGRect(x: (bounds.width - logoWidth) / 2,
                                                  y: (bounds.height - logoHeight) / 2,
                                                  width: logoWidth,
                                                  height: logoHeight))
        logoImageView.image = logoImage
        logoImageView.imageScaling = .scaleProportionallyUpOrDown
        logoImageView.wantsLayer = true // This enables layer-backing for the view
        logoImageView.layer?.zPosition = 1
        addSubview(logoImageView)
    }

    
    override func animateOneFrame() {
        super.animateOneFrame()
        updateCirclePositionAndColor(circle: &circle, velocity: &circleVelocity, currentColor: circle.fillColor)
        updateCirclePositionAndColor(circle: &circle2, velocity: &circle2Velocity, currentColor: circle2.fillColor)
    }

    func updateCirclePositionAndColor(circle: inout CircleView, velocity: inout CGPoint, currentColor: NSColor) {
        var newFrame = circle.frame
        newFrame.origin.x += velocity.x
        newFrame.origin.y += velocity.y

        if newFrame.maxX > bounds.maxX || newFrame.minX < bounds.minX || newFrame.maxY > bounds.maxY || newFrame.minY < bounds.minY {
            velocity.x *= (newFrame.maxX > bounds.maxX || newFrame.minX < bounds.minX) ? -1 : velocity.x
            velocity.y *= (newFrame.maxY > bounds.maxY || newFrame.minY < bounds.minY) ? -1 : velocity.y
            circle.fillColor = nextRandomColor(currentColor: currentColor)
        }

        circle.frame = newFrame
        self.needsDisplay = true
    }
    
    func nextRandomColor(currentColor: NSColor) -> NSColor {
        var availableColors = colorArray.filter { $0 != currentColor }
        if availableColors.isEmpty {
            return currentColor
        }
        return availableColors.randomElement() ?? currentColor
    }
}

// Custom view to draw a circle
class CircleView: NSView {
    var fillColor: NSColor = .red {
        didSet {
            self.needsDisplay = true
        }
    }
    
    init(frame: CGRect, color: NSColor) {
        self.fillColor = color
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        fillColor.setFill()
        let path = NSBezierPath(ovalIn: bounds)
        path.fill()
    }
}
