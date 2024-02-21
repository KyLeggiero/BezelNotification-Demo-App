//
//  SwiftUI window translucency.swift
//  BlueToast Demo App
//
//  Created by The Northstar✨ System on 2024-02-13.
//  Copyright © 2024 Ky Leggiero. All rights reserved.
//

import SwiftUI



public struct BackgroundMaterial: NSViewRepresentable {
    private let material: Material
    private let blendingMode: BlendingMode
    private let state: State
    private let isEmphasized: Bool
    
    init(
        material: Material,
        blendingMode: BlendingMode = .default,
        state: State = .default,
        emphasized: Bool = false)
    {
        self.material = material
        self.blendingMode = blendingMode
        self.state = state
        self.isEmphasized = emphasized
    }
    
    
    public func makeNSView(context: Context) -> NSVisualEffectView {
        let nsView = NSVisualEffectView()
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.isEmphasized = isEmphasized
        nsView.state = state
        
        // Not certain how necessary this is
        nsView.autoresizingMask = [.width, .height]
        
        return nsView
    }
    
    
    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = context.environment.visualEffectMaterial ?? material
        nsView.blendingMode = context.environment.visualEffectBlending ?? blendingMode
        nsView.isEmphasized = context.environment.visualEffectEmphasized ?? isEmphasized
        nsView.state = context.environment.visualEffectState ?? state
    }
    
    
    
    public typealias Material = NSVisualEffectView.Material
    public typealias BlendingMode = NSVisualEffectView.BlendingMode
    public typealias State = NSVisualEffectView.State
}



public extension BackgroundMaterial.Material {
    static let `default` = Self.underWindowBackground
}



public extension BackgroundMaterial.BlendingMode {
    static let `default` = Self.behindWindow
}



public extension BackgroundMaterial.State {
    static let `default` = Self.followsWindowActiveState
}



private extension EnvironmentValues {
    var visualEffectMaterial: BackgroundMaterial.Material? {
        get { self[BackgroundMaterial.MaterialKey.self] }
        set { self[BackgroundMaterial.MaterialKey.self] = newValue }
    }
    
    
    var visualEffectBlending: BackgroundMaterial.BlendingMode? {
        get { self[BackgroundMaterial.BlendingKey.self] }
        set { self[BackgroundMaterial.BlendingKey.self] = newValue }
    }
    
    
    var visualEffectEmphasized: Bool? {
        get { self[BackgroundMaterial.EmphasizedKey.self] }
        set { self[BackgroundMaterial.EmphasizedKey.self] = newValue }
    }
    
    
    var visualEffectState: BackgroundMaterial.State? {
        get { self[BackgroundMaterial.StateKey.self] }
        set { self[BackgroundMaterial.StateKey.self] = newValue }
    }
}



private extension BackgroundMaterial {
    struct MaterialKey: EnvironmentKey {
        static var defaultValue: Material? = nil
    }
    
    
    
    struct BlendingKey: EnvironmentKey {
        static var defaultValue: BlendingMode? = nil
    }
    
    
    
    struct EmphasizedKey: EnvironmentKey {
        static var defaultValue: Bool? = nil
    }
    
    
    
    struct StateKey: EnvironmentKey {
        static var defaultValue: State? = nil
    }
}



public extension View {
    func background<Modified: View>(
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode = .default,
        state: NSVisualEffectView.State = .default,
        emphasized: Bool = false,
        modifier: (BackgroundMaterial) -> Modified)
    -> some View {
        background {
            modifier(
                BackgroundMaterial(
                    material: material,
                    blendingMode: blendingMode,
                    state: state,
                    emphasized: emphasized
                )
            )
        }
    }
    
    
    @inline(__always)
    func background(
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode = .default,
        state: NSVisualEffectView.State = .default,
        emphasized: Bool = false)
    -> some View {
        background(
            material: material,
            blendingMode: blendingMode,
            state: state,
            emphasized: emphasized,
            modifier: { $0 })
    }
}



#Preview {
    VStack {
        Rectangle()
            .fill(.clear)
            .background(material: .underWindowBackground, blendingMode: .behindWindow, state: .active, emphasized: false) {
                $0.clipShape(RoundedRectangle(cornerRadius: 100, style: .continuous))
            }
        
        BackgroundMaterial(material: .underWindowBackground, blendingMode: .behindWindow, state: .active, emphasized: false)
        
        
            ZStack {
                    VStack {
                        Image("Notification-Test-Image")
                            .frame(width: 150, height: 150)
                    }
                    .background {
                        BackgroundMaterial(material: .underWindowBackground, blendingMode: .behindWindow, state: .active, emphasized: false)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
            }
    }
}
