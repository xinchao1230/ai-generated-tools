# Window Viewer - Real-time Window Properties Tool

A Windows GUI tool for real-time monitoring of window properties without changing focus. This tool is specifically designed to debug popup windows and other focus-sensitive windows that disappear when they lose focus.

## Features

- **Real-time Monitoring**: Displays properties of three types of windows simultaneously:
  - Window under mouse cursor
  - Currently focused window
  - Active (foreground) window

- **Window Properties Displayed**:
  - Window handle (HWND)
  - Class name
  - Window text/title
  - Process ID
  - Position and size
  - Window styles (WS_POPUP, WS_CHILD, etc.)
  - Extended window styles (WS_EX_TOPMOST, WS_EX_LAYERED, etc.)
  - Visibility status

- **Ancestor Tree View**: Shows the complete hierarchy of parent windows (can be toggled on/off)

- **Non-intrusive**: Designed to not steal focus from the windows being monitored

- **Configurable Update Rate**: Adjust the refresh interval from 50ms to 5000ms

## Installation

1. Make sure you have Python 3.x installed on Windows
2. Clone or download this repository
3. No additional dependencies required - uses only Python standard library

## Usage

Run the tool from command line:

```bash
python window_viewer.py
```

Or double-click `window_viewer.py` if Python is associated with .py files.

## Interface

The tool has three tabs:
1. **Window Under Mouse**: Shows properties of the window directly under the mouse cursor
2. **Focused Window**: Shows properties of the window that has keyboard focus
3. **Active Window**: Shows properties of the foreground window

### Controls
- **Update Interval**: Adjust how frequently the window information refreshes
- **Show Ancestor Trees**: Toggle display of parent window hierarchies

## Use Cases

- **Debugging Popup Windows**: Monitor properties of popup windows that disappear when clicked outside
- **Window Style Analysis**: Understand window styles and extended styles of any window
- **Parent-Child Relationships**: Trace window ownership and parent-child relationships
- **Focus Tracking**: Monitor which window has focus vs which is active

## Technical Details

The tool uses Windows API functions through Python's `ctypes` library:
- `GetCursorPos` and `WindowFromPoint` for mouse position tracking
- `GetForegroundWindow` and `GetFocus` for active/focused windows
- `GetWindowLong` for window styles
- `GetParent` and `GetAncestor` for window hierarchy

## Demo Application

A demo application (`demo_popup.py`) is included to test the Window Viewer with different window types:

```bash
python demo_popup.py
```

The demo creates:
- **Focus-Sensitive Popup**: A popup that disappears when it loses focus
- **Tooltip Window**: A tooltip-style window
- **Layered Window**: A semi-transparent window

Run both the Window Viewer and the demo side by side to see how the tool captures window properties without interfering with focus-sensitive windows.

## Building Executable

To create standalone .exe files that don't require Python:

1. Install build requirements:
   ```bash
   pip install -r requirements-build.txt
   ```

2. Run the build script:
   ```bash
   python build_exe.py
   ```

Or simply run `build.bat` which does both steps.

The executables will be created in the `dist` folder:
- `WindowViewer.exe` - Main application
- `WindowViewerDemo.exe` - Demo application

## Known Limitations

- Some protected system windows may not expose all properties
- Focus detection may be limited for windows from different processes
- The tool window itself appears in window listings

## License

This tool is provided as-is for debugging and development purposes.