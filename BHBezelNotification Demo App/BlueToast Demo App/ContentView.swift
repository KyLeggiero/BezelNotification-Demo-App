//
//  ContentView.swift
//  BHBezelNotification Demo App
//
//  Created by The Northstar✨ System on 2024-02-12.
//  Copyright © 2024 Blue Husky Studios. All rights reserved.
//

import SwiftUI

import BlueToast
import CrossKitTypes



let linkUrl = URL(string: "https://KyLeggiero.me")!



struct ContentView: View {
    
    @State
    private var selectedToastStyle: SelectedToastStyle = .systemBezel
    
    @State
    private var icon: Image? = Image("Notification-Test-Image")
    
    @State
    private var messageText: String = ""
    
    @State
    private var showToast = false
    
    
    var body: some View {
        VStack {
            Picker("Toast style", selection: $selectedToastStyle) {
                ForEach(SelectedToastStyle.allCases) { selectedToastStyle in
                    Text(selectedToastStyle.title)
                        .id(selectedToastStyle)
                        .tag(selectedToastStyle)
                }
            }
            .pickerStyle(.segmented)
            
            ZStack {
                previewToast
            }
            .frame(maxHeight: .infinity)
            
            HStack(alignment: .bottom) {
                Link("Made by Ky", destination: linkUrl)
                    .controlSize(.mini)
                    .foregroundStyle(.secondary)
                
                
                Spacer()
                
                
                Button("Hide All") {
                    showToast = false
                }
                    .disabled(!showToast)
                
                Button("Show") {
                    showToast = true
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .toast(isPresented: $showToast, text: messageText, icon: icon)
//        .toastStyle(selectedToastStyle.toastStyle)
        .environment(\.toastStyle, selectedToastStyle.toastStyle)
    }
    
    
    var previewToast: some View {
        VStack(spacing: 0) {
            ImagePicker(selectedImage: $icon)
                .imagePickerStyle(.plain)
                .frame(width: 150, height: 150)
                .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            TextField("Message Text", text: $messageText, prompt: Text("Message Text"))
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
                .frame(width: 150)
                .fixedSize()
                .textFieldStyle(.plain)
                .padding(.bottom, 20)
        }
        .blendMode(.screen)
        .frame(width: 200, height: 200)
        .background {
            BackgroundMaterial(material: .hudWindow, blendingMode: .behindWindow, state: .active, emphasized: false)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .preferredColorScheme(.dark)
        }
    }
}



private enum SelectedToastStyle: String, Identifiable, CaseIterable {
    case systemBezel
    case snackbar
    
    
    
    public var id: String { rawValue }
}


private extension SelectedToastStyle {
    var title: LocalizedStringKey {
        switch self {
        case .systemBezel: "System Bezel"
        case .snackbar:    "Snackbar"
        }
    }
    
    
    var toastStyle: any ToastStyle {
        switch self {
        case .systemBezel: .systemBezel
        case .snackbar:    .snackbar
        }
    }
}



private extension SystemBezelNotification.TimeToLive {
    
    static let presets: [Self] = [.short, .long, .forever]
    
    
    init?(named name: String) {
        if let found = Self.presets.first(where: { $0.name == name }) {
            self = found
        }
        else {
            return nil
        }
    }
    
    
    var name: String {
        switch self {
        case .short: return "Short"
        case .long: return "Long"
        case .forever: return "Forever"
        case .exactly(let seconds): return "\(seconds) Seconds"
        }
    }
}


#Preview {
    ContentView()
}
