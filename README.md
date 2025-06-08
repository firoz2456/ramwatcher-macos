# RAMWatcher 🖥️💾

A lightweight, native macOS menu bar application for real-time RAM usage monitoring. Optimized for Apple Silicon (M1/M2/M3) and Intel Macs.

## ✨ Features

- 📊 **Real-time Memory Monitoring** - Updates every 2 seconds in your menu bar
- 🚦 **Visual Status Indicators**
  - 🟢 Green: ≤60% usage (Good)
  - 🟡 Yellow: 61-85% usage (Warning)
  - 🔴 Red: >85% usage (Critical)
- 📈 **Detailed Memory Breakdown** - Click to see active, wired, compressed, and free memory
- 🚀 **Lightweight & Native** - Built with Swift and SwiftUI for minimal resource usage
- 🔒 **Privacy-Focused** - No data collection, runs entirely locally
- 💻 **Universal Support** - Works on Intel and Apple Silicon Macs

## 🔧 Requirements

- macOS 13.0 Ventura or later
- 10MB of disk space

## 📦 Installation

### Option 1: Download Pre-built App
1. Download the latest `RAMWatcher.dmg` from [Releases](https://github.com/yourusername/RAMWatcher/releases)
2. Double-click the DMG file
3. Drag RAMWatcher to your Applications folder
4. Launch RAMWatcher from Applications or Spotlight

### Option 2: Build from Source
```bash
# Clone the repository
git clone https://github.com/yourusername/RAMWatcher.git
cd RAMWatcher

# Build the app
./build.sh

# The DMG will be created in the build/ directory
```

## 🚀 Usage

Once installed, RAMWatcher will appear in your menu bar showing:

```
🟡 8.5/16.0 GB
```

- **Click** the menu bar item to see detailed memory breakdown
- **Open Activity Monitor** directly from the popup
- **Quit** the app from the popup menu

## 🛠️ Development

### Building from Source

Requirements:
- Xcode 15.0+ or Swift 5.9+
- macOS 13.0+

```bash
# Clone and build
git clone https://github.com/yourusername/RAMWatcher.git
cd RAMWatcher
./build.sh
```

### Project Structure

```
RAMWatcher/
├── RAMWatcher/              # Main app source code
│   ├── MemoryMonitor.swift  # Core memory monitoring logic
│   ├── RAMWatcherApp.swift  # App entry point
│   └── ...                  # Other Swift files
├── build.sh                 # Build script
├── README.md               # This file
└── .gitignore             # Git ignore rules
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with Swift and SwiftUI
- Uses macOS native Mach APIs for memory monitoring
- Inspired by the need for a simple, lightweight memory monitor

---

Made with ❤️ for the Mac community