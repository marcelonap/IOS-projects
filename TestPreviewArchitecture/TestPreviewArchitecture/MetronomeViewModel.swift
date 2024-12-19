//
//  MetronomeViewModel.swift
//  TestPreviewArchitecture
//
//  Created by Marcelo Napoleao Sampaio on 2024-12-18.
//


import Foundation
import Combine

// State representation
struct MetronomeState {
    var bpm: Double
    var timeSignature: Int
    var isPlaying: Bool
    var beats: [Int]
    var beatNumber: Int
    
    static let initial = MetronomeState(
        bpm: 120.0,
        timeSignature: 4,
        isPlaying: false,
        beats: [2,3,5,4,6,8],
        beatNumber: 1
    )
}

// Events that can occur in the UI
struct MetronomeEvents {
    let onBpmChanged: (Double) -> Void
    let onTimeSignatureChanged: (Int) -> Void
    let onPlayToggled: () -> Void
    
    static let preview = MetronomeEvents(
        onBpmChanged: { _ in },
        onTimeSignatureChanged: { _ in },
        onPlayToggled: {}
    )
}



// ViewModel that manages state and handles events
class MetronomeViewModel: ObservableObject {
    @Published private(set) var state: MetronomeState = .initial
    private let metronomeManager: MetronomeManager
    
    private var cancellables: Set<AnyCancellable> = []
    
    var events: MetronomeEvents {
        MetronomeEvents(
            onBpmChanged: { [weak self] newBpm in
                self?.metronomeManager.updateBpm(newBpm)
            },
            onTimeSignatureChanged: { [weak self] newTimeSignature in
                self?.metronomeManager.updateTimeSignature(newTimeSignature)
            },
            onPlayToggled: { [weak self] in
                guard let self = self else { return }
                self.metronomeManager.toggleMetronome()

            }
        )
    }
    
    func subscribeToStateSync(){
        
    }
    
    init(metronomeManager: MetronomeManager ) {
        self.metronomeManager = metronomeManager
        self.state = MetronomeState(bpm: metronomeManager.bpm, timeSignature: metronomeManager.timeSignature, isPlaying: metronomeManager.isPlaying, beats: metronomeManager.beats, beatNumber: metronomeManager.beatNumber)
        
        metronomeManager.$state
            .sink{ [weak self] newState in
                self?.state = MetronomeState(
                    bpm: newState.bpm,
                    timeSignature: newState.timeSignature,
                    isPlaying: newState.isPlaying,
                    beats: newState.beats,
                    beatNumber: newState.beatNumber)
            }
            .store(in: &cancellables)
    }
}
