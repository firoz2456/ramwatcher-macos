import Cocoa
import Foundation

/// Launch helper application for starting RAMWatcher at login
@main
class LaunchAtLoginHelper: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Get the main app bundle identifier
        let mainAppBundleIdentifier = "com.ramwatcher.app"
        
        // Check if the main app is already running
        let runningApps = NSWorkspace.shared.runningApplications
        let isMainAppRunning = runningApps.contains { app in
            app.bundleIdentifier == mainAppBundleIdentifier
        }
        
        if !isMainAppRunning {
            // Launch the main app
            let configuration = NSWorkspace.OpenConfiguration()
            configuration.activates = false // Don't bring to front
            configuration.hides = true // Keep hidden
            
            NSWorkspace.shared.openApplication(
                at: mainAppURL(),
                configuration: configuration
            ) { app, error in
                if let error = error {
                    print("Failed to launch main app: \(error)")
                } else {
                    print("Successfully launched main app")
                }
                
                // Terminate this helper app
                NSApp.terminate(nil)
            }
        } else {
            // Main app is already running, just terminate this helper
            print("Main app is already running")
            NSApp.terminate(nil)
        }
    }
    
    /// Get the URL of the main application
    private func mainAppURL() -> URL {
        // Get the path to this helper app
        let helperURL = Bundle.main.bundleURL
        
        // Navigate to the main app: Helper.app -> Contents/Library/LoginItems -> Contents -> Applications -> MainApp.app
        let mainAppURL = helperURL
            .deletingLastPathComponent() // Remove Helper.app
            .deletingLastPathComponent() // Remove LoginItems
            .deletingLastPathComponent() // Remove Library
            .deletingLastPathComponent() // Remove Contents
            .appendingPathComponent("MacOS")
            .appendingPathComponent("RAMWatcher")
        
        // Alternative approach: look for the main app in the parent bundle
        let alternativeURL = helperURL
            .deletingLastPathComponent() // Remove Helper.app
            .deletingLastPathComponent() // Remove LoginItems
            .deletingLastPathComponent() // Remove Library
            .deletingLastPathComponent() // Remove Contents
        
        return alternativeURL
    }
}