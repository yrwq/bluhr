//
//  AppDelegate.swift
//  bluhr
//
//  Created by yrwq on 2025. 07. 07..
//

import SwiftUI
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var screenPanels: [NSScreen: NSPanel] = [:]
    private var screenObservers: [NSScreen: NSKeyValueObservation] = [:]
    private let multiMonitorManager = MultiMonitorManager.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // notification for screen changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenParametersDidChange(_:)),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil)
        
        // MultiMonitorManager notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenDidConnect(_:)),
            name: .screenDidConnect,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenDidDisconnect(_:)),
            name: .screenDidDisconnect,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenFrameDidChange(_:)),
            name: .screenFrameDidChange,
            object: nil)
        
        // initial setup
        setupAllScreens()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // clean up all panels and observers
        cleanupAllScreens()
    }

    @objc private func screenParametersDidChange(_ notification: Notification) {
        setupAllScreens()
    }
    
    @objc private func screenDidConnect(_ notification: Notification) {
        guard let screen = notification.object as? NSScreen else { return }
        setupPanelForScreen(screen)
    }
    
    @objc private func screenDidDisconnect(_ notification: Notification) {
        guard let screen = notification.object as? NSScreen else { return }
        removePanelForScreen(screen)
    }
    
    @objc private func screenFrameDidChange(_ notification: Notification) {
        guard let screen = notification.object as? NSScreen,
              let userInfo = notification.userInfo,
              let _ = userInfo["oldFrame"] as? CGRect,
              let newFrame = userInfo["newFrame"] as? CGRect else { return }
        
        updatePanelForScreen(screen, frame: newFrame)
    }
    
    private func setupAllScreens() {
        // clean up existing panels and observers
        cleanupAllScreens()
        
        // get all available screens from MultiMonitorManager
        let screens = multiMonitorManager.screens
        
        for screen in screens {
            setupPanelForScreen(screen)
        }
    }
    
    private func setupPanelForScreen(_ screen: NSScreen) {
        let frame = screen.frame
        
        // create panel for this screen
        let panel = createPanel(for: screen, frame: frame)
        screenPanels[screen] = panel
        
        // observe screen frame changes
        let observer = screen.observe(\.frame, options: [.new, .old]) { [weak self] screen, change in
            guard let self = self,
                  let newFrame = change.newValue,
                  let oldFrame = change.oldValue,
                  newFrame != oldFrame else { return }
            
            self.updatePanelForScreen(screen, frame: newFrame)
        }
        screenObservers[screen] = observer
        
        // order panel to front
        panel.orderFront(nil)
    }
    
    private func removePanelForScreen(_ screen: NSScreen) {
        // remove observer
        screenObservers[screen]?.invalidate()
        screenObservers.removeValue(forKey: screen)
        
        // close and remove panel
        if let panel = screenPanels[screen] {
            panel.close()
            screenPanels.removeValue(forKey: screen)
        }
    }
    
    private func createPanel(for screen: NSScreen, frame: CGRect) -> NSPanel {
        let panel = NSPanel(
            contentRect: frame,
            styleMask: [.nonactivatingPanel],
            backing: .buffered,
            defer: false)
        
        panel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.isOpaque = false
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        
        // create a screen-specific background view
        let backgroundView = BackgroundView(screen: screen)
        panel.contentView = NSHostingView(rootView: backgroundView)
        
        return panel
    }
    
    private func updatePanelForScreen(_ screen: NSScreen, frame: CGRect) {
        guard let panel = screenPanels[screen] else { return }
        
        // update panel frame
        panel.setFrame(frame, display: true)
        
        // update content view if needed
        if let hostingView = panel.contentView as? NSHostingView<BackgroundView> {
            let updatedBackgroundView = BackgroundView(screen: screen)
            hostingView.rootView = updatedBackgroundView
        }
    }
    
    private func cleanupAllScreens() {
        // remove all observers
        for observer in screenObservers.values {
            observer.invalidate()
        }
        screenObservers.removeAll()
        
        // close all panels
        for panel in screenPanels.values {
            panel.close()
        }
        screenPanels.removeAll()
    }
}
