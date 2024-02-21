//
//  ImagePickerStyle.swift
//  BlueToast Demo App
//
//  Created by The Northstar✨ System on 2024-02-15.
//  Copyright © 2024 Ky Leggiero. All rights reserved.
//

import SwiftUI



/// Allows you to style the appearance of an image picker.
///
/// This does not currently allow you to change the behavior of the image picker, just the appearance.
public protocol ImagePickerStyle {
    
    associatedtype Body: View
    
    @ViewBuilder
    func body(_ configuration: Configuration) -> Body
    
    
    
    typealias Configuration = ImagePickerStyleConfiguration
}



// MARK: - API

public extension View {
    func imagePickerStyle<Style: ImagePickerStyle>(_ style: Style) -> some View {
        environment(\.imagePickerStyle, style)
    }
}



// MARK: - Configuration

public struct ImagePickerStyleConfiguration {
    
    /// The image that the user has selected
    let selectedImage: Image?
}



// MARK: - Environment

internal extension EnvironmentValues {
    var imagePickerStyle: any ImagePickerStyle {
        get { self[ImagePickerStyle.EnvironmentKey.self] }
        set { self[ImagePickerStyle.EnvironmentKey.self] = newValue }
    }
}



internal extension ImagePickerStyle {
    typealias EnvironmentKey = ImagePickerStyleEnvironmentKey
}



internal struct ImagePickerStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: any ImagePickerStyle {
        BezelImagePickerStyle()
    }
}



// MARK: - Bezel

/// The traditional "image well" appearance of an image picker, with a rounded rectangle stroke around a fill indicating a click/drop point
public struct BezelImagePickerStyle<Background: ShapeStyle, Stroke: ShapeStyle>: ImagePickerStyle {
    
    private let background: Background
    private let stroke: Stroke
    private let innerPadding: CGFloat?
    
    public init(
        background: Background,
        stroke: Stroke,
        innerPadding: CGFloat? = nil)
    {
        self.background = background
        self.stroke = stroke
        self.innerPadding = innerPadding
    }
    
    
    public func body(_ configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(background)
            .stroke(stroke, lineWidth: 2)
            .overlay {
                if let selectedImage = configuration.selectedImage {
                    selectedImage
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .padding(.all, innerPadding)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
    }
}



public extension BezelImagePickerStyle where Background == HierarchicalShapeStyle {
    init(stroke: Stroke, innerPadding: CGFloat? = nil) {
        self.init(
            background: .quaternary,
            stroke: stroke,
            innerPadding: innerPadding)
    }
}



public extension BezelImagePickerStyle where Stroke == HierarchicalShapeStyle {
    init(background: Background, innerPadding: CGFloat? = nil) {
        self.init(
            background: background,
            stroke: .tertiary,
            innerPadding: innerPadding)
    }
}



public extension BezelImagePickerStyle where Background == HierarchicalShapeStyle, Stroke == HierarchicalShapeStyle {
    init(innerPadding: CGFloat? = nil) {
        self.init(
            background: .quaternary,
            stroke: .tertiary,
            innerPadding: innerPadding)
    }
}



public extension ImagePickerStyle where Self == BezelImagePickerStyle<HierarchicalShapeStyle, HierarchicalShapeStyle> {
    static var bezel: Self { .init() }
}



// MARK: - Plain

/// Just shows the selected image (if there is one) and nothing else
public struct PlainImagePickerStyle: ImagePickerStyle {
    
    public func body(_ configuration: Configuration) -> some View {
        if let selectedImage = configuration.selectedImage {
            selectedImage
                .resizable(resizingMode: .stretch)
                .aspectRatio(contentMode: .fit)
                .padding()
        }
        else {
            Rectangle()
                .fill(.clear)
        }
    }
}



public extension ImagePickerStyle where Self == PlainImagePickerStyle {
    static var plain: Self { .init() }
}
