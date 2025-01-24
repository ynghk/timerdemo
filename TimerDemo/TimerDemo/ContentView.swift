//
//  ContentView.swift
//  TimerDemo
//
//  Created by Yung Hak Lee on 1/24/25.
//

import SwiftUI
import AVFoundation

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

struct TimerPicker: View {
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    @State private var timeRemaining = 0
    @State private var startTime = 0
    @State private var twentyFourHours = 86400
    @State private var isReset = false
    @State private var isRunning: Bool = false
    @State private var widthValue: CGFloat = 100
    @State private var set24Hours = false
    @State private var isOnTop = true
    
    @State private var showingSetTimer = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        HStack(alignment: .top) {
            Button(action: {
                isOnTop.toggle()
            }) {
                Image(systemName: isOnTop ? "pin.fill" : "pin.slash")
            }.buttonStyle(PlainButtonStyle())
                .padding()
        }
        
        Text("\(timeRemaining / 3600):\(String(format: "%02d", (timeRemaining % 3600) / 60)):\(String(format: "%02d", timeRemaining % 60))")
            .font(.system(size: 80))
            .fontWeight(.bold)
        VStack {
            HStack {
                Button(action: {
                    isRunning.toggle()
                }) {
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding()
                }
                Button(action: {
                    isReset.toggle()
                    timeRemaining = startTime
                    isRunning = false
                }) {
                    Image(systemName: "arrow.trianglehead.clockwise")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding()
                }
                Button(action: {
                    showingSetTimer = true
//                    set24Hours.toggle()
//                    timeRemaining = twentyFourHours
                }) {
                    Image(systemName: "24.square.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding()
                }
            }
        }
        .sheet(isPresented: $showingSetTimer) {
            VStack {
                HStack {
                    HStack {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24) { hour in
                                Text("\(hour)").tag(hour)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 100, height: 100)
                        .clipped()
                        
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60) { minute in
                                Text("\(minute)").tag(minute)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 120, height: 100)
                        .clipped()
                        
                        Picker("Seconds", selection: $seconds) {
                            ForEach(0..<60) { second in
                                Text("\(second)").tag(second)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 120, height: 100)
                        .clipped()
                    }
                    Button(action: {
                        hours = 0
                        minutes = 0
                        seconds = 0
                    }) {
                        Image(systemName: "gobackward")
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
                HStack {
                    Button(action: setTimer) {
                        Text("Set Time")
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .font(.title)
                            .clipped()
                    }.buttonStyle(.plain)
                }
            }
        }
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if widthValue > 0 && startTime > 0 {
                    widthValue -= 100 / CGFloat(startTime)
                }
                if timeRemaining <= 10 {
                    NSSound.beep()
                }
            } else if isRunning {
                isRunning = false
                widthValue = 100
                timeRemaining = startTime
            }
        }
    }
    func setTimer() {
        let totalSeconds = hours * 3600 + minutes * 60 + seconds
        timeRemaining = totalSeconds
        startTime = totalSeconds
        isRunning = false
        widthValue = 100
        showingSetTimer = false
    }
}


struct ContentView: View {
    
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            TimerPicker(hours: $hours, minutes: $minutes, seconds: $seconds)
        }
    }
}

#Preview {
    ContentView()
}
