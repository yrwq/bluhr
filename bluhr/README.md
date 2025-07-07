# Bluhr - Wallpaper Blur Wrapper

Bluhr is a macOS application that acts as a wrapper for your desktop wallpaper, applying a beautiful blur effect to create a more focused and aesthetic desktop experience.

## Features

- **Automatic Wallpaper Detection**: Automatically captures your current desktop wallpaper
- **Real-time Blur Effect**: Applies a Gaussian blur filter to your wallpaper
- **Dynamic Updates**: Automatically refreshes when you change your wallpaper
- **Background Operation**: Runs as a background service with a minimal UI
- **Multi-Screen Support**: Works across all connected displays

## How It Works

Bluhr creates a transparent panel that sits behind your desktop icons and windows, displaying a blurred version of your wallpaper. This creates a beautiful depth effect while maintaining the functionality of your desktop.

## Installation

1. Build the project in Xcode
2. Run the application
3. Grant necessary permissions when prompted:
   - Screen Recording access (for wallpaper capture)
   - Accessibility access (for desktop overlay)

## Usage

1. **Launch the App**: Double-click the Bluhr app to start
2. **Grant Permissions**: When prompted, allow screen recording and accessibility access
3. **Enjoy**: Your wallpaper will now appear blurred behind your desktop icons

The app runs in the background with a minimal control window. You can close the control window and the blur effect will continue to work.

## Technical Details

- Built with SwiftUI and AppKit
- Uses Core Image filters for blur processing
- Implements desktop-level window management
- Monitors wallpaper changes for automatic updates

## Requirements

- macOS 12.0 or later
- Screen Recording permission
- Accessibility permission (optional, for better integration)

## Troubleshooting

If the blur effect isn't working:

1. Check System Preferences > Security & Privacy > Privacy > Screen Recording
2. Ensure Bluhr is enabled in the list
3. Restart the application after granting permissions

## Development

This project is built with:
- SwiftUI for the UI
- AppKit for system integration
- Core Image for image processing
- NotificationCenter for wallpaper change detection

## License

This project is open source and available under the MIT License. 