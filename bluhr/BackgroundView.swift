//
//  BackgroundView.swift
//  bluhr
//
//  Created by yrwq on 2025. 07. 08..
//

import SwiftUI
import AppKit

struct BackgroundView: View {
    let screen: NSScreen
    
    init(screen: NSScreen = NSScreen.main ?? NSScreen.screens.first ?? NSScreen.main!) {
        self.screen = screen
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // transparent background to let wallpaper show through
                Color.clear
                
                BlurOverlayView(screen: screen)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct BlurOverlayView: NSViewRepresentable {
    let screen: NSScreen
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        
        let blurView1 = NSVisualEffectView()
        blurView1.material = getBlurMaterial(for: screen)
        blurView1.state = .active
        blurView1.blendingMode = .behindWindow
        blurView1.frame = view.bounds
        blurView1.autoresizingMask = [.width, .height]
        
        let blurView2 = NSVisualEffectView()
        blurView2.material = getSecondaryBlurMaterial(for: screen)
        blurView2.state = .active
        blurView2.blendingMode = .behindWindow
        blurView2.frame = view.bounds
        blurView2.autoresizingMask = [.width, .height]
        
        let blurView3 = NSVisualEffectView()
        blurView3.material = getTertiaryBlurMaterial(for: screen)
        blurView3.state = .active
        blurView3.blendingMode = .behindWindow
        blurView3.frame = view.bounds
        blurView3.autoresizingMask = [.width, .height]
        
        view.addSubview(blurView1)
        view.addSubview(blurView2)
        view.addSubview(blurView3)
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // Update if needed
    }
    
    private func getBlurMaterial(for screen: NSScreen) -> NSVisualEffectView.Material {
        // different blur materials based on screen properties
        if screen.backingScaleFactor > 2.0 {
            // retina
            return .hudWindow
        } else if screen.frame.width > 3000 {
            // ultra-wide
            return .popover
        } else {
            // standard
            return .menu
        }
    }
    
    private func getSecondaryBlurMaterial(for screen: NSScreen) -> NSVisualEffectView.Material {
        if screen.backingScaleFactor > 2.0 {
            return .popover
        } else {
            return .hudWindow
        }
    }
    
    private func getTertiaryBlurMaterial(for screen: NSScreen) -> NSVisualEffectView.Material {
        if screen.frame.width > 3000 {
            return .hudWindow
        } else {
            return .popover
        }
    }
}
