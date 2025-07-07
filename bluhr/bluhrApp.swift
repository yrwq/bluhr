//
//  bluhrApp.swift
//  bluhr
//
//  Created by yrwq on 2025. 07. 07..
//

import SwiftUI

@main
struct bluhrApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Bluhr - Wallpaper Blur Wrapper")
                .font(.title2)
                .foregroundColor(.white)
            Text("Your wallpaper is now blurred in the background")
                .font(.caption)
                .foregroundColor(.gray)
            Text("Check your desktop for the blur overlay")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .frame(width: 300, height: 150)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}
