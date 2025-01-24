//
//  ContentView.swift
//  TimerDemo
//
//  Created by Yung Hak Lee on 1/24/25.
//

import SwiftUI
import AVFoundation




struct ContentView: View {
    
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            TimerPickerView(hours: $hours, minutes: $minutes, seconds: $seconds)
        }
        .frame(width: 400, height: 200)
    }
    struct AlwaysOnTopView: NSViewRepresentable {
        let window: NSWindow
        let isAlwaysOnTop: Bool
        
        func makeNSView(context: Context) -> NSView {
            let view = NSView()
            return view
        }
        
        func updateNSView(_ nsView: NSView, context: Context) {
            if isAlwaysOnTop {
                window.level = .floating
            } else {
                window.level = .normal
            }
        }
    }
}
#Preview {
    ContentView()
}
