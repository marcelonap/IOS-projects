//
//  TestPreviewArchitectureApp.swift
//  TestPreviewArchitecture
//
//  Created by Marcelo Napoleao Sampaio on 2024-12-18.
//

import SwiftUI

@main
struct TestPreviewArchitectureApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UiStateViewModel(metronomeManager: MetronomeManager()))
        }
    }
}
