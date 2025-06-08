import Foundation
import Combine

/// Memory statistics representing system RAM usage
public struct MemoryStats {
    /// Total physical memory in bytes
    public let totalMemory: UInt64
    /// Used memory in bytes (wired + active + compressed)
    public let usedMemory: UInt64
    /// Wired memory in bytes (cannot be paged out)
    public let wiredMemory: UInt64
    /// Active memory in bytes (currently being used)
    public let activeMemory: UInt64
    /// Compressed memory in bytes (stored in compressed form)
    public let compressedMemory: UInt64
    /// Free memory in bytes
    public let freeMemory: UInt64
    
    /// Memory usage percentage (0.0 to 1.0)
    public var usagePercentage: Double {
        guard totalMemory > 0 else { return 0.0 }
        return Double(usedMemory) / Double(totalMemory)
    }
    
    /// Total memory in gigabytes
    public var totalGB: Double {
        return Double(totalMemory) / (1024 * 1024 * 1024)
    }
    
    /// Used memory in gigabytes
    public var usedGB: Double {
        return Double(usedMemory) / (1024 * 1024 * 1024)
    }
    
    /// Memory usage indicator based on percentage thresholds
    public var indicator: MemoryIndicator {
        let percentage = usagePercentage
        if percentage <= 0.60 {
            return .green
        } else if percentage <= 0.85 {
            return .yellow
        } else {
            return .red
        }
    }
}

/// Color-coded memory usage indicator
public enum MemoryIndicator {
    case green, yellow, red
    
    /// Emoji representation of the indicator
    public var emoji: String {
        switch self {
        case .green: return "🟢"
        case .yellow: return "🟡"
        case .red: return "🔴"
        }
    }
}

/// Singleton class for monitoring system memory usage using Mach APIs
@MainActor
public class MemoryMonitor: ObservableObject {
    /// Shared singleton instance
    public static let shared = MemoryMonitor()
    
    /// Published memory statistics that UI can observe
    @Published public private(set) var stats = MemoryStats(
        totalMemory: 0,
        usedMemory: 0,
        wiredMemory: 0,
        activeMemory: 0,
        compressedMemory: 0,
        freeMemory: 0
    )
    
    /// Polling interval in seconds (configurable)
    public var pollingInterval: TimeInterval = 2.0 {
        didSet {
            restartTimer()
        }
    }
    
    private var timer: Timer?
    private let pageSize: UInt64
    
    private init() {
        // Get system page size
        var size = vm_size_t()
        host_page_size(mach_host_self(), &size)
        self.pageSize = UInt64(size)
        
        // Initial memory read
        updateMemoryStats()
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    /// Start periodic memory monitoring
    public func startMonitoring() {
        startTimer()
    }
    
    /// Stop periodic memory monitoring
    public func stopMonitoring() {
        stopTimer()
    }
    
    /// Manually refresh memory statistics
    public func refresh() {
        updateMemoryStats()
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: pollingInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateMemoryStats()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func restartTimer() {
        if timer != nil {
            startTimer()
        }
    }
    
    /// Update memory statistics using host_statistics64 Mach API
    private func updateMemoryStats() {
        var vmStats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.stride / MemoryLayout<integer_t>.stride)
        
        let result = withUnsafeMutablePointer(to: &vmStats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        
        guard result == KERN_SUCCESS else {
            print("Failed to get VM statistics: \(result)")
            return
        }
        
        // Calculate memory values in bytes
        let freePages = UInt64(vmStats.free_count)
        let activePages = UInt64(vmStats.active_count)
        let inactivePages = UInt64(vmStats.inactive_count)
        let wiredPages = UInt64(vmStats.wire_count)
        let compressedPages = UInt64(vmStats.compressor_page_count)
        
        let freeMemory = freePages * pageSize
        let activeMemory = activePages * pageSize
        let inactiveMemory = inactivePages * pageSize
        let wiredMemory = wiredPages * pageSize
        let compressedMemory = compressedPages * pageSize
        
        // Get total physical memory
        let totalMemory = getTotalPhysicalMemory()
        
        // Calculate used memory (active + wired + compressed)
        let usedMemory = activeMemory + wiredMemory + compressedMemory
        
        // Update published stats
        self.stats = MemoryStats(
            totalMemory: totalMemory,
            usedMemory: usedMemory,
            wiredMemory: wiredMemory,
            activeMemory: activeMemory,
            compressedMemory: compressedMemory,
            freeMemory: freeMemory
        )
    }
    
    /// Get total physical memory using sysctl
    private func getTotalPhysicalMemory() -> UInt64 {
        var size = 0
        var result = sysctlbyname("hw.memsize", nil, &size, nil, 0)
        guard result == 0 else { return 0 }
        
        var memsize: UInt64 = 0
        result = sysctlbyname("hw.memsize", &memsize, &size, nil, 0)
        guard result == 0 else { return 0 }
        
        return memsize
    }
}