//
//  ImagePicker.swift
//  BlueToast Demo App
//
//  Created by The Northstar✨ System on 2024-02-14.
//  Copyright © 2024 Ky Leggiero. All rights reserved.
//

import SwiftUI
import PhotosUI

import CrossKitTypes
import SimpleLogging



internal struct ImagePicker: View {
    
    @Binding
    var selectedImage: Image?
    
    @State
    private var showPhotosPickerSheet = false
    
    @State
    private var photosPickerItem: PhotosPickerItem? = nil
    
    @Environment(\.imagePickerStyle)
    private var style
    
    
    public var body: some View {
        AnyView(style.body(configuration))
        
            .photosPicker(isPresented: $showPhotosPickerSheet, selection: $photosPickerItem)
        
            .onTapGesture {
                showPhotosPickerSheet = true
            }
        
            .onChange(of: photosPickerItem) { oldValue, newValue in
                guard let newValue else {
                    selectedImage = nil
                    return
                }
                
                newValue.loadTransferable(type: NativeImage.self) { result in
                    switch result {
                    case .failure(let failure):
                        log(error: failure)
                        
                    case .success(.some(let image)):
                        selectedImage = Image(nativeImage: image)
                        
                    case .success(nil):
                        selectedImage = nil
                    }
                }
            }
    }
    
    
    private var configuration: ImagePickerStyle.Configuration {
        .init(selectedImage: selectedImage)
    }
}



#Preview {
    HStack {
        VStack {
            ImagePicker(selectedImage: .constant(nil))
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .padding()
            
            ImagePicker(selectedImage: .constant(Image("Notification-Test-Image")))
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .padding()
        }
        
        VStack {
            ImagePicker(selectedImage: .constant(nil))
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .padding()
            
            ImagePicker(selectedImage: .constant(Image("Notification-Test-Image")))
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .padding()
        }
        .imagePickerStyle(.plain)
    }
}
