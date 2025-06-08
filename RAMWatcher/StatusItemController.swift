import AppKit
import SwiftUI

/// Controller for managing the macOS menu bar status item
@MainActor
public class StatusItemController: ObservableObject {
    private var statusItem: NSStatusItem?
    private var memoryMonitor = MemoryMonitor.shared
    private var popover: NSPopover?
    
    /// Initialize and create the status item
    public init() {
        setupStatusItem()
        setupPopover()
    }
    
    deinit {
        statusItem = nil
    }
    
    /// Create and configure the status bar item
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusItem = statusItem else { return }
        
        if let button = statusItem.button {
            button.action = #selector(statusItemClicked(_:))
            button.target = self
            updateStatusItemTitle()
            
            // Update title when memory stats change
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("MemoryStatsUpdated"),
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateStatusItemTitle()
            }
        }
        
        // Start monitoring memory stats and observe changes
        memoryMonitor.startMonitoring()
        observeMemoryChanges()
    }
    
    /// Setup the popover for detailed memory information
    private func setupPopover() {
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 280, height: 200)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(
            rootView: MemoryPopoverView()
        )
    }
    
    /// Update the status item title with current memory usage
    private func updateStatusItemTitle() {
        guard let button = statusItem?.button else { return }
        
        let stats = memoryMonitor.stats
        let usedGB = String(format: "%.1f", stats.usedGB)
        let totalGB = String(format: "%.1f", stats.totalGB)
        let indicator = stats.indicator.emoji
        
        button.title = "\(indicator) \(usedGB)/\(totalGB) GB"
    }
    
    /// Handle status item click to show/hide popover
    @objc private func statusItemClicked(_ sender: NSStatusBarButton) {
        guard let popover = popover else { return }
        
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
        }
    }
    
    /// Observe memory statistics changes and update UI
    private func observeMemoryChanges() {
        // Since MemoryMonitor uses @Published, we can observe its changes
        // This is a simple notification-based approach for the status item
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateStatusItemTitle()
            }
        }
    }
    
    /// Show the popover programmatically
    public func showPopover() {
        guard let statusItem = statusItem,
              let button = statusItem.button,
              let popover = popover else { return }
        
        if !popover.isShown {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    
    /// Hide the popover programmatically
    public func hidePopover() {
        popover?.performClose(nil)
    }
}

/// Legacy NSStatusBar-based implementation for macOS versions prior to 13.0
@available(macOS, deprecated: 13.0, message: "Use MenuBarExtra for macOS 13.0+")
@MainActor
public class LegacyStatusItemController: ObservableObject {
    private var statusItem: NSStatusItem?
    private var memoryMonitor = MemoryMonitor.shared
    private var popover: NSPopover?
    
    public init() {
        setupStatusItem()
        setupPopover()
    }
    
    deinit {
        NSStatusBar.system.removeStatusItem(statusItem!)
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusItem = statusItem else { return }
        
        if let button = statusItem.button {
            button.action = #selector(statusItemClicked(_:))
            button.target = self
            updateStatusItemTitle()
        }
        
        memoryMonitor.startMonitoring()
        observeMemoryChanges()
    }
    
    private func setupPopover() {
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 280, height: 200)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(
            rootView: MemoryPopoverView()
        )
    }
    
    private func updateStatusItemTitle() {
        guard let button = statusItem?.button else { return }
        
        let stats = memoryMonitor.stats
        let usedGB = String(format: "%.1f", stats.usedGB)
        let totalGB = String(format: "%.1f", stats.totalGB)
        let indicator = stats.indicator.emoji
        
        button.title = "\(indicator) \(usedGB)/\(totalGB) GB"
    }
    
    @objc private func statusItemClicked(_ sender: NSStatusBarButton) {
        guard let popover = popover else { return }
        
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
        }
    }
    
    private func observeMemoryChanges() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateStatusItemTitle()
            }
        }
    }
}