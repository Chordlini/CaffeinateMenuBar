import IOKit.pwr_mgt

class CaffeinateManager {
    private var assertionID: IOPMAssertionID = 0
    private var assertionCreated = false
    
    func start() {
        guard !assertionCreated else { return }
        let reason = "CaffeinateMenuBar preventing idle sleep" as CFString
        let result = IOPMAssertionCreateWithName(
            kIOPMAssertionTypeNoIdleSleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason,
            &assertionID
        )
        if result == kIOReturnSuccess {
            assertionCreated = true
            print("Caffeinate: ON")
        } else {
            print("Caffeinate: failed to start")
        }
    }
    
    func stop() {
        guard assertionCreated else { return }
        IOPMAssertionRelease(assertionID)
        assertionCreated = false
        print("Caffeinate: OFF")
    }
}
