//
//  UiStateViewModel.swift
//  TestPreviewArchitecture
//
//  Created by Marcelo Napoleao Sampaio on 2024-12-18.
//

import Foundation


class UiStateViewModel: ObservableObject {
    
    @Published var metronomeManager: MetronomeManager
    @Published var isPlaying: Bool = false
    
    init(metronomeManager: MetronomeManager){
        self.metronomeManager = metronomeManager
    }
    
    func onMetronomeToggle(){
        DispatchQueue.main.async {
            self.metronomeManager.toggleMetronome()
            self.isPlaying = self.metronomeManager.isPlaying
        }
    }
}
