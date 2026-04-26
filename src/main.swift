import Cocoa
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        registerLoginItem()
        statusBarController = StatusBarController()
        print("CaffeinateMenuBar launched")
    }
    
    private func registerLoginItem() {
        if #available(macOS 13.0, *) {
            do {
                let service = SMAppService.mainApp
                if service.status == .notRegistered {
                    try service.register()
                    print("Registered as login item")
                }
            } catch {
                print("Failed to register login item: \(error)")
            }
        }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
