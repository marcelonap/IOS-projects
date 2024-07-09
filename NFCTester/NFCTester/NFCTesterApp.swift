//
//  NFCTesterApp.swift
//  NFCTester
//
//  Created by Marcelo Napoleao Sampaio on 2024-03-29.
//

import SwiftUI

@main
struct NFCTesterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(NFCReaderViewModel())
                
        }
    }
}
