import SwiftUI

/// Main content view for legacy macOS support (pre-13.0)
struct ContentView: View {
    @StateObject private var memoryMonitor = MemoryMonitor.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("RAMWatcher")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Memory monitoring is running in the menu bar")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Used Memory:")
                    Spacer()
                    Text("\(String(format: "%.1f", memoryMonitor.stats.usedGB)) GB")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Total Memory:")
                    Spacer()
                    Text("\(String(format: "%.1f", memoryMonitor.stats.totalGB)) GB")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Usage:")
                    Spacer()
                    HStack(spacing: 4) {
                        Text(memoryMonitor.stats.indicator.emoji)
                        Text("\(String(format: "%.1f", memoryMonitor.stats.usagePercentage * 100))%")
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Text("This window can be closed. The app will continue running in the menu bar.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: 300)
        .onAppear {
            memoryMonitor.startMonitoring()
        }
    }
}

#Preview {
    ContentView()
}