import Cocoa

class TestIconRenderer {
    static func render(isActive: Bool, phase: Double, size: NSSize) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        
        NSGraphicsContext.current?.cgContext.setShouldAntialias(true)
        
        // Dark background for visibility
        if size.width > 22 {
            NSColor.darkGray.setFill()
            NSRect(origin: .zero, size: size).fill()
        }
        
        drawCup(in: NSRect(origin: .zero, size: size))
        
        if isActive {
            drawSteam(in: NSRect(origin: .zero, size: size), phase: phase)
        }
        
        image.unlockFocus()
        return image
    }
    
    private static func drawCup(in rect: NSRect) {
        let color = NSColor.labelColor
        color.setStroke()
        
        let path = NSBezierPath()
        path.lineWidth = 2.0
        path.lineCapStyle = .round
        
        let left: CGFloat = 5
        let right: CGFloat = 15
        let top: CGFloat = 12
        let bottom: CGFloat = 3
        
        path.move(to: NSPoint(x: left, y: top))
        path.line(to: NSPoint(x: left, y: bottom + 2))
        path.curve(to: NSPoint(x: right, y: bottom + 2),
                   controlPoint1: NSPoint(x: left, y: bottom),
                   controlPoint2: NSPoint(x: right, y: bottom))
        path.line(to: NSPoint(x: right, y: top))
        
        path.stroke()
        
        let handle = NSBezierPath()
        handle.lineWidth = 2.0
        handle.lineCapStyle = .round
        
        handle.move(to: NSPoint(x: right, y: top - 2))
        handle.curve(to: NSPoint(x: right + 4, y: top - 4),
                     controlPoint1: NSPoint(x: right + 2, y: top - 2),
                     controlPoint2: NSPoint(x: right + 4, y: top - 3))
        handle.curve(to: NSPoint(x: right, y: bottom + 3),
                     controlPoint1: NSPoint(x: right + 4, y: bottom + 5),
                     controlPoint2: NSPoint(x: right + 2, y: bottom + 3))
        
        handle.stroke()
    }
    
    private static func drawSteam(in rect: NSRect, phase: Double) {
        let accent = NSColor.controlAccentColor
        let positions: [CGFloat] = [7, 10, 13]
        
        for (i, x) in positions.enumerated() {
            let offset = Double(i) * 2.3
            let localPhase = phase + offset
            let cycle = 3.0
            let progress = fmod(localPhase, cycle) / cycle
            
            let startY: CGFloat = 13
            let rise: CGFloat = 8
            let y = startY + CGFloat(progress) * rise
            
            let wiggle = sin(localPhase * 2.5) * 1.5
            let finalX = x + CGFloat(wiggle)
            
            let alpha = (1.0 - progress) * 0.9 + 0.15
            
            let color = accent.withAlphaComponent(CGFloat(alpha))
            color.setStroke()
            
            let path = NSBezierPath()
            path.lineWidth = 1.8
            path.lineCapStyle = .round
            
            path.move(to: NSPoint(x: finalX, y: y))
            path.curve(to: NSPoint(x: finalX + CGFloat(sin(localPhase * 3.5) * 1.0), y: y + 3.5),
                       controlPoint1: NSPoint(x: finalX + CGFloat(cos(localPhase * 2.8) * 0.5), y: y + 1.2),
                       controlPoint2: NSPoint(x: finalX + CGFloat(sin(localPhase * 3.2) * 0.8), y: y + 2.5))
            
            path.stroke()
        }
    }
}

func savePNG(_ image: NSImage, to path: String) {
    guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
        print("Failed to create CGImage")
        return
    }
    let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
    bitmapRep.size = image.size
    guard let data = bitmapRep.representation(using: .png, properties: [:]) else {
        print("Failed to create PNG data")
        return
    }
    try? data.write(to: URL(fileURLWithPath: path))
    print("Saved to \(path)")
}

let off88 = TestIconRenderer.render(isActive: false, phase: 0, size: NSSize(width: 88, height: 88))
let on88 = TestIconRenderer.render(isActive: true, phase: 1.5, size: NSSize(width: 88, height: 88))

savePNG(off88, to: "/Users/rami/CaffeinateMenuBar/preview_off_88.png")
savePNG(on88, to: "/Users/rami/CaffeinateMenuBar/preview_on_88.png")
