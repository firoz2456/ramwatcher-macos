import SwiftUI

/// Main application entry point for RAMWatcher
@main
struct RAMWatcherApp: App {
    @StateObject private var memoryMonitor = MemoryMonitor.shared
    
    var body: some Scene {
        MenuBarExtra {
            MemoryPopoverView()
        } label: {
            MenuBarLabel()
        }
        .menuBarExtraStyle(.window)
    }
}

/// MenuBar label view
struct MenuBarLabel: View {
    @StateObject private var memoryMonitor = MemoryMonitor.shared
    
    var body: some View {
        HStack(spacing: 2) {
            Text(memoryMonitor.stats.indicator.emoji)
            Text("\(String(format: "%.1f", memoryMonitor.stats.usedGB))/\(String(format: "%.1f", memoryMonitor.stats.totalGB)) GB")
                .font(.system(size: 12, weight: .medium, design: .monospaced))
        }
        .onAppear {
            memoryMonitor.startMonitoring()
        }
    }
}