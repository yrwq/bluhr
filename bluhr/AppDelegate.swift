//
//  AppDelegate.swift
//  bluhr
//
//  Created by yrwq on 2025. 07. 07..
//

import SwiftUI
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var backgroundPanel: NSPanel?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set up notifications for screen changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenParametersDidChange(_:)),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil)
        
        // Initial setup
        setupPanels()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Clean up panels
        backgroundPanel?.close()
        backgroundPanel = nil
    }

    @objc private func screenParametersDidChange(_ notification: Notification) {
        setupPanels()
    }

    private func setupPanels() {
        guard let screenFrame = NSScreen.main?.frame else { return }
        setupPanel(
            &backgroundPanel,
            frame: screenFrame,
            level: Int(CGWindowLevelForKey(.desktopWindow)),
            hostingRootView: AnyView(BackgroundView()))
    }

    private func setupPanel(
        _ panel: inout NSPanel?, frame: CGRect, level: Int,
        hostingRootView: AnyView
    ) {
        if let existingPanel = panel {
            existingPanel.setFrame(frame, display: true)
            return
        }

        let newPanel = NSPanel(
            contentRect: frame,
            styleMask: [.nonactivatingPanel],
            backing: .buffered,
            defer: false)
        newPanel.level = NSWindow.Level(rawValue: level)
        newPanel.backgroundColor = .clear
        newPanel.hasShadow = false
        newPanel.isOpaque = false
        newPanel.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        newPanel.contentView = NSHostingView(rootView: hostingRootView)
        newPanel.orderFront(nil)
        newPanel.makeKeyAndOrderFront(nil)
        panel = newPanel
        
        print("Background panel created with frame: \(frame)")
    }
}
