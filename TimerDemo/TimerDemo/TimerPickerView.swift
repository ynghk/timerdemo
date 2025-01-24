//
//  TimerPickerView.swift
//  TimerDemo
//
//  Created by Yung Hak Lee on 1/25/25.
//

import SwiftUI
import AVFoundation

struct TimerPickerView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int
    @State private var timeRemaining = 60
    @State private var startTime = 60
    @State private var customTimeSet = false
    @State private var twentyFourHours = 86400
    @State private var isReset = false
    @State private var isRunning: Bool = false
    @State private var set24Hours = false
    @State private var isOnTop = false
    @State private var showingSetTimer = false
    @State private var tenSeconds = 10
    @State private var thirtySeconds = 30
    
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
                    showingSetTimer.toggle()
                }) {
                    Image(systemName: "plus.square")
                        .resizable()
                        .frame(width: 10, height: 10)
                    
                }
                Button(action: {
                    isRunning.toggle()
                }) {
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                    
                }
                Button(action: {
                    setTimer()
                    isRunning = false
                }) {
                    Image(systemName: "arrow.trianglehead.clockwise")
                        .resizable()
                        .frame(width: 10, height: 10)
                    
                }
            }
        }
        .sheet(isPresented: $showingSetTimer) {
            VStack{
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
                        customTimeSet = false
                        timeRemaining = 60
                        startTime = 60
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
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 10 {
                    NSSound.beep()
                }
            } else if isRunning {
                isRunning = false
                if customTimeSet {
                    timeRemaining = startTime
                } else {
                    timeRemaining = 60
                    startTime = 60
                }
            }
        }
    }
    func setTimer() {
        let totalSeconds = hours * 3600 + minutes * 60 + seconds
        if totalSeconds > 0 {
            timeRemaining = totalSeconds
            startTime = totalSeconds
            customTimeSet = true
        } else {
            timeRemaining = 60
            startTime = 60
            customTimeSet = false
        }

        isRunning = false
        showingSetTimer = false
    }
}

#Preview {
    ContentView()
}
