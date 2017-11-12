//
//  AppDelegate.swift
//  BH Bezel Test App
//
//  Created by Ben Leggiero on 2017-11-09.
//  Copyright © 2017 Ben Leggiero. All rights reserved.
//

import Cocoa
import BHBezelNotification



let copyrightUrl = URL(string: "https://Soft.BHStudios.org")!
let copyrightText = "©2017\nBlue Husky Studios"



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
        
        messageTextField.font = BezelParameters.defaultMessageLabelFont
        
        copyrightButton.attributedTitle = NSAttributedString(
            string: copyrightText,
            attributes: [
                .foregroundColor : NSColor.tertiaryLabelColor,
                .font : NSFont.systemFont(forControlSize: .mini)
            ])
        
        visualEffectBackgroundFrameObservation =
            visualEffectBackground.observe(\.frame, options: .new) { (visualEffectBackground, change) in
                print("visualEffectBackground.frame:", change)
                // FIXME: For some reason, it's drawing non-retina... this is my workaround for now.
                let cornerRadius = BezelParameters.defaultCornerRadius / visualEffectBackground.layer!.contentsScale
                visualEffectBackground.maskImage = .roundedRectMask(size: visualEffectBackground.frame.size,
                                                                    cornerRadius: cornerRadius)
        }
        
        copyrightButton.cursor = .pointingHand
        
        tintColorWell.color = BezelParameters.defaultMessageLabelColor
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    private var delegates = [UUID : BezelDelegate]()


    @IBAction func didPressShowBezelButton(_ sender: NSButton) {
        let timeToLive: BezelTimeToLive
        
        if let selectedTTLName = timeToLivePopUpButton.selectedItem?.title {
            timeToLive = BezelTimeToLive(named: selectedTTLName) ?? .short
        }
        else {
            timeToLive = .short
        }
        
        let delegateId = UUID()
        
        delegates[delegateId] = BHNotificationBezel.show(
            messageText: messageTextField.stringValue,
            icon: iconImageWell.image,
            timeToLive: timeToLive,
            tint: tintColorWell.color
            )
        { [weak weakSelf = self] in
            guard let weakSelf = weakSelf else {
                assertionFailure()
                return
            }
            weakSelf.delegates.removeValue(forKey: delegateId)
            let anyDelegatesRemaining = !weakSelf.delegates.isEmpty
            weakSelf.hideAllBezelsButton.isEnabled = anyDelegatesRemaining
            weakSelf.hideAllBezelsButton.isHidden = !anyDelegatesRemaining
        }
        
        self.hideAllBezelsButton.isEnabled = true
        self.hideAllBezelsButton.isHidden = false
    }
    
    
    @IBAction func didPressHideAllBezelsButton(_ sender: NSButton) {
        delegates.forEach { $0.value.donePresentingBezel() }
    }
    
    
    @IBAction func didPressCopyright(_ sender: NSButton) {
        NSWorkspace.shared.open(copyrightUrl)
    }
}



extension AppDelegate : NSWindowDelegate {
    
}



private extension BezelTimeToLive {
    
    static let presets: [BezelTimeToLive] = [.short, .long, .forever]
    
    
    init?(named name: String) {
        if let found = BezelTimeToLive.presets.first(where: { $0.name == name }) {
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
