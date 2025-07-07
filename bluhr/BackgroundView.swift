//
//  BackgroundView.swift
//  bluhr
//
//  Created by yrwq on 2025. 07. 08..
//

import SwiftUI
import AppKit

struct BackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Transparent background to let wallpaper show through
                Color.clear
                
                // Blur overlay using NSVisualEffectView
                BlurOverlayView()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct BlurOverlayView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        
        // Create multiple visual effect views for layered blur
        let blurView1 = NSVisualEffectView()
        blurView1.material = .hudWindow
        blurView1.state = .active
        blurView1.blendingMode = .behindWindow
        blurView1.frame = view.bounds
        blurView1.autoresizingMask = [.width, .height]
        
        let blurView2 = NSVisualEffectView()
        blurView2.material = .menu
        blurView2.state = .active
        blurView2.blendingMode = .behindWindow
        blurView2.frame = view.bounds
        blurView2.autoresizingMask = [.width, .height]
        
        let blurView3 = NSVisualEffectView()
        blurView3.material = .popover
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
}
