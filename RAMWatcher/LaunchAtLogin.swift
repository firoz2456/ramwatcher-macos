import Foundation
import ServiceManagement
import os.log

/// Manager for handling launch-at-login functionality
@MainActor
public class LaunchAtLoginManager: ObservableObject {
    /// Shared singleton instance
    public static let shared = LaunchAtLoginManager()
    
    /// Bundle identifier for the launch helper
    private let helperBundleIdentifier = "com.ramwatcher.helper"
    
    /// Logger for debugging
    private let logger = Logger(subsystem: "com.ramwatcher.app", category: "LaunchAtLogin")
    
    /// Published property indicating if launch at login is enabled
    @Published public private(set) var isEnabled: Bool = false
    
    private init() {
        updateStatus()
    }
    
    /// Enable or disable launch at login
    /// - Parameter enabled: Whether to enable launch at login
    /// - Returns: Success of the operation
    @discardableResult
    public func setEnabled(_ enabled: Bool) -> Bool {
        logger.info("Setting launch at login to: \(enabled)")
        
        if #available(macOS 13.0, *) {
            return setEnabledModern(enabled)
        } else {
            return setEnabledLegacy(enabled)
        }
    }
    
    /// Modern implementation using SMAppService (macOS 13.0+)
    @available(macOS 13.0, *)
    private func setEnabledModern(_ enabled: Bool) -> Bool {
        do {
            if enabled {
                if SMAppService.mainApp.status == .enabled {
                    logger.info("Launch at login already enabled")
                    isEnabled = true
                    return true
                }
                
                try SMAppService.mainApp.register()
                logger.info("Successfully registered for launch at login")
                isEnabled = true
                return true
            } else {
                try SMAppService.mainApp.unregister()
                logger.info("Successfully unregistered from launch at login")
                isEnabled = false
                return true
            }
        } catch {
            logger.error("Failed to \(enabled ? "register" : "unregister") launch at login: \(error.localizedDescription)")
            updateStatus()
            return false
        }
    }
    
    /// Legacy implementation using SMLoginItemSetEnabled (pre-macOS 13.0)
    private func setEnabledLegacy(_ enabled: Bool) -> Bool {
        let success = SMLoginItemSetEnabled(helperBundleIdentifier as CFString, enabled)
        
        if success {
            logger.info("Successfully \(enabled ? "enabled" : "disabled") launch at login (legacy)")
            isEnabled = enabled
        } else {
            logger.error("Failed to \(enabled ? "enable" : "disable") launch at login (legacy)")
            updateStatus()
        }
        
        return success
    }
    
    /// Update the current status of launch at login
    private func updateStatus() {
        if #available(macOS 13.0, *) {
            updateStatusModern()
        } else {
            updateStatusLegacy()
        }
    }
    
    /// Update status using modern API (macOS 13.0+)
    @available(macOS 13.0, *)
    private func updateStatusModern() {
        isEnabled = SMAppService.mainApp.status == .enabled
        logger.debug("Current launch at login status (modern): \(self.isEnabled)")
    }
    
    /// Update status using legacy API (pre-macOS 13.0)
    private func updateStatusLegacy() {
        // For legacy systems, we check if our helper is in the login items
        isEnabled = isHelperInLoginItems()
        logger.debug("Current launch at login status (legacy): \(self.isEnabled)")
    }
    
    /// Check if the helper app is currently in login items (legacy method)
    private func isHelperInLoginItems() -> Bool {
        guard let jobDicts = SMCopyAllJobDictionaries(kSMDomainUserLaunchd)?.takeRetainedValue() as? [[String: Any]] else {
            return false
        }
        
        return jobDicts.contains { dict in
            dict["Label"] as? String == helperBundleIdentifier
        }
    }
    
    /// Toggle launch at login status
    public func toggle() {
        setEnabled(!isEnabled)
    }
    
    /// Refresh the current status
    public func refresh() {
        updateStatus()
    }
}

/// Extension providing convenience computed properties
public extension LaunchAtLoginManager {
    /// Convenience property for toggling launch at login
    var launchAtLogin: Bool {
        get { isEnabled }
        set { setEnabled(newValue) }
    }
}