//
//  MusicTerminalApp.swift
//  MusicTerminal
//
//  Created by Marcelo Napoleao Sampaio on 2024-02-04.
//

import SwiftUI
import SwiftData

@main
struct MusicTerminalApp: App {

    var body: some Scene {
        WindowGroup {
            InitialView()
                .environmentObject(BluetoothManager())
        }
    }
}
