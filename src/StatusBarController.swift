import Cocoa

class StatusBarController: NSObject {
    private var statusItem: NSStatusItem!
    private let caffeinateManager = CaffeinateManager()
    private var timer: Timer?
    private var steamPhase: Double = 0
    
    private var isActive: Bool {
        didSet {
            updateIcon()
            if isActive {
                caffeinateManager.start()
                startAnimation()
            } else {
                caffeinateManager.stop()
                stopAnimation()
            }
            UserDefaults.standard.set(isActive, forKey: "CaffeinateMenuBar.isActive")
        }
    }
    
    override init() {
        isActive = UserDefaults.standard.bool(forKey: "CaffeinateMenuBar.isActive")
        super.init()
        setupStatusItem()
        updateIcon()
        if isActive {
            caffeinateManager.start()
            startAnimation()
        }
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.action = #selector(toggle)
            button.target = self
            button.appearsDisabled = false
        }
    }
    
    @objc private func toggle() {
        isActive.toggle()
    }
    
    private func startAnimation() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 15.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.steamPhase += 0.12
            self.updateIcon()
        }
    }
    
    private func stopAnimation() {
        timer?.invalidate()
        timer = nil
        steamPhase = 0
        updateIcon()
    }
    
    private func updateIcon() {
        let icon = IconRenderer.render(isActive: isActive, phase: steamPhase, size: NSSize(width: 22, height: 22))
        statusItem.button?.image = icon
    }
}
