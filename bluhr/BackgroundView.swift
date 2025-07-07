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
                // Main blur overlay
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .blur(radius: 50)
                
                // Secondary blur layer
                Rectangle()
                    .fill(Color.black.opacity(0.1))
                    .blur(radius: 30)
                
                // Additional visual elements to make overlay more obvious
                ForEach(0..<5) { i in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: CGFloat(100 + i * 50), height: CGFloat(100 + i * 50))
                        .blur(radius: CGFloat(20 + i * 10))
                        .offset(x: CGFloat(i * 100), y: CGFloat(i * 50))
                }
                
                // Subtle grid pattern
                VStack(spacing: 50) {
                    ForEach(0..<10) { _ in
                        HStack(spacing: 50) {
                            ForEach(0..<20) { _ in
                                Rectangle()
                                    .fill(Color.white.opacity(0.02))
                                    .frame(width: 2, height: 2)
                            }
                        }
                    }
                }
                .blur(radius: 5)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
