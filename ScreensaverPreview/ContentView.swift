import SwiftUI
import ScreenSaver

struct ContentView: View {
    let timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()
    @State private var refresh: Bool = false

    var body: some View {
        GrassViewRepresentable(refresh: $refresh)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .onReceive(timer) { _ in
                refresh.toggle()
            }
    }
}

struct GrassViewRepresentable: NSViewRepresentable {
    @Binding var refresh: Bool
    
    func makeNSView(context: Context) -> NSView {
        // Instead of using nil-coalescing, handle the error directly.
        guard let grassView = GrassScreenSaverView(frame: NSRect(x: 0, y: 0, width: 1680, height: 1050), isPreview: false) else {
            fatalError("Failed to initialize GrassScreenSaverView")
        }
        
        grassView.startAnimation()
        return grassView
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        nsView.setNeedsDisplay(nsView.bounds)
    }
}
