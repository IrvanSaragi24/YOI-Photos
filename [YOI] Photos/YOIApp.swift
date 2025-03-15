//
//  WarmCoolerDetectApp.swift
//  WarmCoolerDetect
//
//  Created by Irvan P. Saragi on 01/03/25.
//

import SwiftUI

@main
struct YOIApp: App {
    
    init() {
        FontFamily.registerAllCustomFonts() // Daftarkan semua font kustom
    }
    
    var body: some Scene {
        WindowGroup {
            ImageWarmCoolerView()
        }
    }
}
