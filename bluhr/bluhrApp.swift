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
        Settings {
            EmptyView()
        }
    }
}
