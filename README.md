# RAMWatcher 🖥️💾

A lightweight, native macOS menu bar application for real-time RAM usage monitoring. Built with Swift and SwiftUI for optimal performance on both Intel and Apple Silicon Macs.

![RAMWatcher Screenshot](https://img.shields.io/badge/macOS-13.0+-blue) ![Swift](https://img.shields.io/badge/Swift-5.9+-orange) ![License](https://img.shields.io/badge/License-MIT-green)

## 📦 Quick Download & Install

### 🚀 Ready to Use - Download Now!

**[⬇️ Download RAMWatcher-v1.0.0.dmg](releases/RAMWatcher-v1.0.0.dmg)** (89KB)


###  Screenshot:

![RamWatcher](https://github.com/user-attachments/assets/853e1d4e-1e4c-4885-8965-be180b95ff5f)

![screen 1](https://github.com/user-attachments/assets/8169fe2c-ada2-42c3-afd8-011a20c076a4)
![screen 2](https://github.com/user-attachments/assets/3fd6dbbd-498a-490d-9096-1d2accbf8f9c)

### 📱 Installation Steps:
1. **Download** the DMG file above
2. **Double-click** the DMG to open it  
3. **Drag** RAMWatcher.app to Applications folder
4. **Launch** from Applications or Spotlight (⌘+Space)
5. **Allow** if macOS shows security warning: System Settings → Privacy & Security → "Open Anyway"

### 💻 Requirements:
- macOS 13.0 Ventura or later
- Intel or Apple Silicon Mac
- 10MB disk space

---

## 📸 Preview

RAMWatcher appears in your menu bar showing real-time memory usage:

```
🟢 6.2/16.0 GB    🟡 12.3/16.0 GB    🔴 14.8/16.0 GB
```

Click the menu bar item to see detailed memory breakdown with a beautiful native popup.

## ✨ Features

### 🚦 Real-time Memory Monitoring
- **Live Updates**: Memory usage refreshes every 2 seconds in your menu bar
- **Smart Display**: Shows used/total memory in GB format (e.g., "8.5/16.0 GB")
- **Zero Performance Impact**: Minimal CPU usage with native macOS APIs

### 🎯 Visual Status Indicators
- 🟢 **Green**: ≤60% usage (Optimal performance)
- 🟡 **Yellow**: 61-85% usage (Moderate usage warning)
- 🔴 **Red**: >85% usage (High usage alert)

### 📊 Detailed Memory Breakdown
Click the menu bar item to view:
- **Active Memory**: Currently used by running applications
- **Wired Memory**: System kernel and drivers (cannot be paged out)
- **Compressed Memory**: Memory compressed to save space
- **Free Memory**: Available for new applications
- **Memory Pressure**: Visual gauge showing overall system memory health

### 🚀 Native & Lightweight
- **Pure Swift**: Built with Swift 5.9+ and SwiftUI for optimal performance
- **Menu Bar Only**: No Dock icon, runs silently in the background
- **Universal Binary**: Optimized for both Intel and Apple Silicon Macs
- **Minimal Footprint**: Less than 5MB installed size

### 🔒 Privacy-Focused
- **No Data Collection**: All monitoring happens locally on your Mac
- **No Network Access**: Zero internet connectivity required
- **Sandboxed**: Runs with minimal system permissions
- **Open Source**: Full transparency with MIT license

### 🛠️ System Integration
- **Activity Monitor Integration**: Quick access to open Activity Monitor
- **Launch at Login**: Optional automatic startup (coming soon)
- **Quit Option**: Clean exit from the menu bar popup

## 💻 System Requirements

- **macOS**: 13.0 Ventura or later
- **Processor**: Intel x64 or Apple Silicon (M1/M2/M3/M4)
- **Memory**: 4GB RAM minimum (works with any amount)
- **Storage**: 10MB available disk space
- **Architecture**: Universal app (arm64 + x86_64)

### Compatibility Table
| macOS Version | Support Status | Notes |
|---------------|----------------|--------|
| macOS 15 Sequoia | ✅ Full Support | Recommended |
| macOS 14 Sonoma | ✅ Full Support | Recommended |
| macOS 13 Ventura | ✅ Full Support | Minimum required |
| macOS 12 Monterey | ❌ Not Supported | MenuBarExtra requires 13.0+ |
| macOS 11 Big Sur | ❌ Not Supported | MenuBarExtra requires 13.0+ |

## 🛠️ Alternative: Build from Source

**For developers who want to build from source:**

```bash
# Clone the repository
git clone https://github.com/firoz2456/ramwatcher-macos.git
cd ramwatcher-macos

# Build the app and create DMG
./build.sh

# The built DMG will be available in the build/ directory
open build/RAMWatcher.dmg
```

**Requirements**: Xcode 15.0+, macOS 13.0+, Swift 5.9+

## 🚀 Usage Guide

### Getting Started

1. **After Installation**: RAMWatcher will automatically appear in your menu bar (top-right area)

2. **Menu Bar Display**: You'll see something like:
   ```
   🟡 8.5/16.0 GB
   ```
   - 🟡 = Status indicator (Green/Yellow/Red)
   - 8.5 = Used memory in GB
   - 16.0 = Total memory in GB

3. **View Details**: Click the menu bar item to see:
   - Detailed memory breakdown
   - Memory pressure gauge
   - Quick actions (Activity Monitor, Quit)

### Understanding the Status Colors

| Color | Memory Usage | Meaning | Action Needed |
|-------|-------------|---------|---------------|
| 🟢 Green | ≤60% | Optimal | None - system running smoothly |
| 🟡 Yellow | 61-85% | Moderate | Consider closing unused apps |
| 🔴 Red | >85% | High | Close apps or restart to free memory |

### Quick Actions

From the popup menu you can:
- **View detailed breakdown** of memory types
- **Open Activity Monitor** to see which apps are using memory
- **Quit RAMWatcher** cleanly

## 🛠️ Development

### Building from Source

```bash
# Clone and build
git clone https://github.com/firoz2456/ramwatcher-macos.git
cd ramwatcher-macos

# Build using the provided script
./build.sh
```

### Project Structure

```
ramwatcher-macos/
├── RAMWatcher/                  # Main app source code
│   ├── MemoryMonitor.swift      # Core memory monitoring with Mach APIs
│   ├── RAMWatcherApp.swift      # SwiftUI app entry point
│   ├── StatusItemController.swift # Menu bar management
│   ├── MemoryPopoverView.swift  # Detailed memory UI
│   ├── LaunchAtLogin.swift      # Launch at startup functionality
│   ├── ContentView.swift        # Main content view
│   ├── Info.plist              # App configuration
│   ├── RAMWatcher.entitlements # App permissions
│   └── Assets.xcassets/        # App icons and resources
├── LaunchAtLoginHelper/         # Helper app for startup (future)
├── build.sh                     # Build script
├── README.md                   # This file
├── LICENSE                     # MIT License
└── .gitignore                 # Git ignore rules
```

### Technical Implementation

- **Memory Monitoring**: Uses native `host_statistics64` Mach API for accurate memory reporting
- **UI Framework**: SwiftUI with `MenuBarExtra` for native menu bar integration
- **Architecture**: `@MainActor` for thread-safe UI updates
- **Performance**: Configurable polling interval (default 2 seconds)
- **Compatibility**: Fallback support for older macOS versions

## 🐛 Troubleshooting

### Common Issues

**Q: RAMWatcher doesn't appear in my menu bar**
- A: Check if it's hidden due to limited menu bar space. Try reducing other menu bar items or use a tool like Bartender.

**Q: I see a security warning when opening the app**
- A: This is normal for unsigned apps. Go to System Settings → Privacy & Security and click "Open Anyway".

**Q: Memory readings seem incorrect**
- A: RAMWatcher uses the same APIs as Activity Monitor. Differences may be due to different memory categorization methods.

**Q: High CPU usage**
- A: RAMWatcher should use <0.1% CPU. If you see higher usage, try restarting the app.

**Q: App crashes on launch**
- A: Ensure you're running macOS 13.0 or later. Check Console.app for crash logs.

### Getting Help

- **Issues**: Report bugs on [GitHub Issues](https://github.com/firoz2456/ramwatcher-macos/issues)
- **Feature Requests**: Use GitHub Issues with the "enhancement" label
- **Discussions**: Use [GitHub Discussions](https://github.com/firoz2456/ramwatcher-macos/discussions) for questions

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow Swift coding conventions
- Add unit tests for new features
- Update documentation for API changes
- Test on both Intel and Apple Silicon Macs

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Apple** for the excellent SwiftUI and Mach APIs
- **macOS Community** for inspiration and feedback
- **Open Source Contributors** who make projects like this possible

## 🔗 Links

- **Repository**: https://github.com/firoz2456/ramwatcher-macos
- **Releases**: https://github.com/firoz2456/ramwatcher-macos/releases
- **Issues**: https://github.com/firoz2456/ramwatcher-macos/issues
- **License**: [MIT License](LICENSE)

---

<div align="center">
<p>Made with ❤️ for the Mac community</p>
<p>⭐ Star this repo if you find it useful!</p>
</div>
