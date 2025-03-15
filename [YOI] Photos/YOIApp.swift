//
//  WarmCoolerDetectApp.swift
//  WarmCoolerDetect
//
//  Created by Irvan P. Saragi on 01/03/25.
//

import SwiftUI
import AVFoundation

@main
struct YOIApp: App {
    
    init() {
        FontFamily.registerAllCustomFonts() // Daftarkan semua font kustom
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default,options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}
