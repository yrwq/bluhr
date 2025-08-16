//
//  MultiMonitorManager.swift
//  bluhr
//
//  Created by yrwq on 2025. 08. 15..
//

import Foundation
import AppKit

class MultiMonitorManager: ObservableObject {
    static let shared = MultiMonitorManager()
    
    @Published var screens: [NSScreen] = []
    @Published var isMultiMonitorSetup: Bool = false
    
    private var screenObservers: [NSScreen: NSKeyValueObservation] = [:]
    
    private init() {
        setupScreenMonitoring()
        updateScreens()
    }
    
    deinit {
        cleanupObservers()
    }
    
    // MARK: - Screen Monitoring
    
    private func setupScreenMonitoring() {
        // monitor for screen changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenParametersDidChange),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
    }
    
    @objc private func screenParametersDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?.updateScreens()
        }
    }
    
    private func updateScreens() {
        let currentScreens = NSScreen.screens
        let previousScreens = Set(screens)
        let newScreens = Set(currentScreens)
        
        // handle disconnected screens
        let disconnectedScreens = previousScreens.subtracting(newScreens)
        for screen in disconnectedScreens {
            handleScreenDisconnection(screen)
        }
        
        // handle new screens
        let connectedScreens = newScreens.subtracting(previousScreens)
        for screen in connectedScreens {
            handleScreenConnection(screen)
        }
        
        // update screens array
        screens = currentScreens
        isMultiMonitorSetup = screens.count > 1
    }
    
    private func handleScreenConnection(_ screen: NSScreen) {
        // observe screen frame changes
        let observer = screen.observe(\.frame, options: [.new, .old]) { [weak self] screen, change in
            guard let self = self,
                  let newFrame = change.newValue,
                  let oldFrame = change.oldValue,
                  newFrame != oldFrame else { return }
            
            self.handleScreenFrameChange(screen, from: oldFrame, to: newFrame)
        }
        screenObservers[screen] = observer
        
        // notify AppDelegate to create panel for this screen
        NotificationCenter.default.post(
            name: .screenDidConnect,
            object: screen
        )
    }
    
    private func handleScreenDisconnection(_ screen: NSScreen) {
        // remove observer
        screenObservers[screen]?.invalidate()
        screenObservers.removeValue(forKey: screen)
        
        // notify AppDelegate to remove panel for this screen
        NotificationCenter.default.post(
            name: .screenDidDisconnect,
            object: screen
        )
    }
    
    private func handleScreenFrameChange(_ screen: NSScreen, from oldFrame: CGRect, to newFrame: CGRect) {
        // notify AppDelegate to update panel
        NotificationCenter.default.post(
            name: .screenFrameDidChange,
            object: screen,
            userInfo: ["oldFrame": oldFrame, "newFrame": newFrame]
        )
    }
    
    private func cleanupObservers() {
        for observer in screenObservers.values {
            observer.invalidate()
        }
        screenObservers.removeAll()
    }
    
    // MARK: - Public API
    
    func refreshAllScreens() {
        updateScreens()
    }
}

// MARK: - Notification Names

extension NSNotification.Name {
    static let screenDidConnect = NSNotification.Name("ScreenDidConnect")
    static let screenDidDisconnect = NSNotification.Name("ScreenDidDisconnect")
    static let screenFrameDidChange = NSNotification.Name("ScreenFrameDidChange")
}
