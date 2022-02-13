//
//  AppDelegate.swift
//  BH Bezel Test App
//
//  Created by Ben Leggiero on 2017-11-09.
//  Copyright © 2017 Ben Leggiero. All rights reserved.
//

import Cocoa
import Combine

import BezelNotification
import FunctionTools



let linkUrl = URL(string: "https://KyLeggiero.me")!
let linkText = "Made by Ky"



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var messageTextField: NSTextField!
    @IBOutlet weak var iconImageWell: NSImageView!
    @IBOutlet weak var timeToLivePopUpButton: NSPopUpButton!
    @IBOutlet weak var visualEffectBackground: NSVisualEffectView!
    @IBOutlet weak var copyrightButton: CustomCursorButton!
    @IBOutlet weak var hideAllBezelsButton: NSButton!
    @IBOutlet weak var tintColorWell: NSColorWell!
    
    private var visualEffectBackgroundFrameObservation: NSKeyValueObservation?
    private var copyrightButtonFrameObservation: NSKeyValueObservation?
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        iconImageWell.image = #imageLiteral(resourceName: "Notification-Test-Image")
        messageTextField.stringValue = "Hello, Bezel!"
        
        timeToLivePopUpButton.removeAllItems()
        timeToLivePopUpButton.addItems(withTitles:
            ["Short", "Long", "Forever"])
        
        messageTextField.font = BezelNotification.Parameters.defaultMessageLabelFont
        
        copyrightButton.attributedTitle = NSAttributedString(
            string: linkText,
            attributes: [
                .foregroundColor : NSColor.tertiaryLabelColor,
                .font : NSFont.systemFont(ofSize: NSFont.systemFontSize(for: .mini))
            ])
        
        visualEffectBackground.wantsLayer = true
        visualEffectBackground.blendingMode = .behindWindow
        visualEffectBackground.material = .hudWindow
        visualEffectBackground.state = .active
        
        let cornerRadius = BezelNotification.Parameters.defaultCornerRadius
        visualEffectBackground.maskImage = .roundedRectMask(size: visualEffectBackground.frame.size,
                                                            cornerRadius: cornerRadius)
        
        copyrightButton.cursor = .pointingHand
        
        tintColorWell.color = BezelNotification.Parameters.defaultBackgroundTint
        NSColorPanel.shared.showsAlpha = true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    private var publishers = Set<AnyCancellable>() {
        didSet {
            print("publishers.count == \(publishers.count)")
            let anyDelegatesRemaining = !self.publishers.isEmpty
            self.hideAllBezelsButton.isEnabled = anyDelegatesRemaining
            self.hideAllBezelsButton.isHidden = !anyDelegatesRemaining
        }
    }


    @IBAction func didPressShowBezelButton(_ sender: NSButton) {
        let timeToLive: BezelNotification.TimeToLive
        
        if let selectedTTLName = timeToLivePopUpButton.selectedItem?.title {
            timeToLive = .init(named: selectedTTLName) ?? .short
        }
        else {
            timeToLive = .short
        }
        
        BezelNotification.show(
            messageText: messageTextField.stringValue,
            icon: iconImageWell.image,
            timeToLive: timeToLive,
            tint: tintColorWell.color)
            .sink(receiveValue: null)
            .store(in: &publishers)
    }
    
    
    @IBAction func didPressHideAllBezelsButton(_ sender: NSButton) {
        publishers = []
    }
    
    
    @IBAction func didPressCopyright(_ sender: NSButton) {
        NSWorkspace.shared.open(linkUrl)
    }
}



extension AppDelegate : NSWindowDelegate {
    
}



private extension BezelNotification.TimeToLive {
    
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
