import SwiftUI
import AppKit

/// Popover view showing detailed memory breakdown and controls
struct MemoryPopoverView: View {
    @StateObject private var memoryMonitor = MemoryMonitor.shared
    @State private var refreshRate: Double = 2.0
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with current usage
            VStack(spacing: 8) {
                HStack {
                    Text(memoryMonitor.stats.indicator.emoji)
                        .font(.title2)
                    Text("Memory Usage")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                // Usage gauge
                MemoryGaugeView(percentage: memoryMonitor.stats.usagePercentage)
                
                HStack {
                    Text("\(String(format: "%.1f", memoryMonitor.stats.usedGB)) GB")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("of \(String(format: "%.1f", memoryMonitor.stats.totalGB)) GB")
                        .font(.body)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(String(format: "%.1f", memoryMonitor.stats.usagePercentage * 100))%")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(colorForPercentage(memoryMonitor.stats.usagePercentage))
                }
            }
            
            Divider()
            
            // Memory breakdown
            VStack(spacing: 6) {
                Text("Memory Breakdown")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                MemoryBreakdownRow(
                    label: "Active",
                    value: memoryMonitor.stats.activeMemory,
                    color: .blue
                )
                
                MemoryBreakdownRow(
                    label: "Wired",
                    value: memoryMonitor.stats.wiredMemory,
                    color: .orange
                )
                
                MemoryBreakdownRow(
                    label: "Compressed",
                    value: memoryMonitor.stats.compressedMemory,
                    color: .purple
                )
                
                MemoryBreakdownRow(
                    label: "Free",
                    value: memoryMonitor.stats.freeMemory,
                    color: .green
                )
            }
            
            Divider()
            
            // Controls
            VStack(spacing: 8) {
                HStack {
                    Text("Refresh Rate:")
                        .font(.caption)
                    Spacer()
                    Text("\(String(format: "%.1f", refreshRate))s")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                Slider(value: $refreshRate, in: 0.5...10.0, step: 0.5)
                    .onChange(of: refreshRate) { _, newValue in
                        memoryMonitor.pollingInterval = newValue
                    }
            }
            
            Divider()
            
            // Action buttons
            HStack(spacing: 12) {
                Button("Activity Monitor") {
                    openActivityMonitor()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Spacer()
                
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .tint(.red)
            }
        }
        .padding(16)
        .frame(width: 280)
        .onAppear {
            refreshRate = memoryMonitor.pollingInterval
        }
    }
    
    /// Open Activity Monitor application
    private func openActivityMonitor() {
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = ["-b", "com.apple.ActivityMonitor"]
        try? task.run()
    }
    
    /// Get color based on memory usage percentage
    private func colorForPercentage(_ percentage: Double) -> Color {
        if percentage <= 0.60 {
            return .green
        } else if percentage <= 0.85 {
            return .orange
        } else {
            return .red
        }
    }
}

/// Memory usage gauge view
struct MemoryGaugeView: View {
    let percentage: Double
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 8)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: percentage)
                .stroke(
                    colorForPercentage(percentage),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: percentage)
        }
        .frame(width: 60, height: 60)
    }
    
    private func colorForPercentage(_ percentage: Double) -> Color {
        if percentage <= 0.60 {
            return .green
        } else if percentage <= 0.85 {
            return .orange
        } else {
            return .red
        }
    }
}

/// Memory breakdown row component
struct MemoryBreakdownRow: View {
    let label: String
    let value: UInt64
    let color: Color
    
    private var valueGB: Double {
        Double(value) / (1024 * 1024 * 1024)
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(label)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(String(format: "%.1f", valueGB)) GB")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    MemoryPopoverView()
        .frame(width: 280, height: 300)
}