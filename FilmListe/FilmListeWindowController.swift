//
//  FilmListeWindowController.swift
//  FilmListe
//
//  Created by MacMini21 on 28.01.24.
//

import Foundation
import Cocoa

class FilmListeWindowController: NSWindowController, NSWindowDelegate {
    
    let minWindowWidth: CGFloat = 1900
    let minWindowHeight: CGFloat = 1000
    let maxWindowWidth: CGFloat = 1900
    let maxWindowHeight: CGFloat = 1000

    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.minSize = CGSize(width: minWindowWidth,
                                 height: minWindowHeight)
        window?.maxSize = CGSize(width: maxWindowWidth,
                                 height: maxWindowHeight)

        window?.makeKeyAndOrderFront(nil)
        window?.center()
    }


    func windowWillClose(_ notification: Notification) 
    {
        print("windowWillClose")
        //let nc = NotificationCenter.default
        //nc.post(name:Notification.Name(rawValue:"beenden"),
        //        object: nil,
         //       userInfo: nil)

        NSApplication.shared.terminate(self)
    }
}
