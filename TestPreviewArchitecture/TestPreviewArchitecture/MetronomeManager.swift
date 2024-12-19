//
//  MetronomeManager.swift
//  TestPreviewArchitecture
//
//  Created by Marcelo Napoleao Sampaio on 2024-12-18.
//

import Foundation

import AVFoundation
import Combine

class MetronomeManager : ObservableObject {
    @Published var timeSignature: Int = 4
    @Published var bpm: Double = 120.0
    @Published var beats: [Int] = [2, 3, 5, 4, 6, 7,8,9,10,11,12,13,33]
    @Published var isPlaying: Bool = false {
        didSet {
            print("isPlaying set to \(isPlaying)")
        }
    }
    @Published var beatNumber = 0
    
    @Published private(set) var state = MetronomeState(
        bpm: 120.0,
        timeSignature: 4,
        isPlaying: false,
        beats: [2, 3, 5, 4, 6, 7,8,9,10,11,12,13],
        beatNumber: 1
    )
    
    private var strongBeatSound: AVAudioPlayer?
    private var weakBeatSound: AVAudioPlayer?
    
    var metronomeQueue = DispatchQueue(label: "MetronomeQueue", qos: .background)
    
    var timeInterval: Double {
        get {
            return 60.0 / bpm
        }
    }
    
    
    var intervalTimer: Timer?
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupAudioPlayers()
        syncUi()
    }
    
    func syncUi(){
        $bpm
            .sink { [weak self] newBpm in
                guard let self = self else { return }
                self.state.bpm = newBpm
            }
            .store(in: &cancellables)
        $timeSignature
            .sink { [weak self] newTimeSignature in
                guard let self = self else { return }
                self.state.timeSignature = newTimeSignature
            }
            .store(in: &cancellables)
    }
    
    func updateBpm(_ newBpm: Double){
        self.bpm = newBpm
    }
    
    func updateTimeSignature(_ newTimeSignature: Int){
        self.timeSignature = newTimeSignature
    }
    
    func toggleMetronome(){
        if isPlaying{
            stopIntervalTimer()
        }else{
            startIntervalTimer()
        }
        isPlaying.toggle()
        state.isPlaying.toggle()
        self.objectWillChange.send()
    }
    
    private func setupAudioPlayers() {
        // You'll need to add these sound files to your project assets
        if let strongBeatPath = Bundle.main.path(forResource: "one", ofType: "mp3") {
            let strongBeatUrl = URL(fileURLWithPath: strongBeatPath)
            do {
                strongBeatSound = try AVAudioPlayer(contentsOf: strongBeatUrl)
                strongBeatSound?.prepareToPlay()
            } catch {
                print("Error loading strong beat sound: \(error.localizedDescription)")
            }
        }
        
        if let weakBeatPath = Bundle.main.path(forResource: "others", ofType: "mp3") {
            let weakBeatUrl = URL(fileURLWithPath: weakBeatPath)
            do {
                weakBeatSound = try AVAudioPlayer(contentsOf: weakBeatUrl)
                weakBeatSound?.prepareToPlay()
            } catch {
                print("Error loading weak beat sound: \(error.localizedDescription)")
            }
        }
    }
    
    func incrementBpm(){
        DispatchQueue.main.async{
            self.bpm += 1
        }
    }
    
    func decrementBpm(){
        DispatchQueue.main.async{
            self.bpm -= 1
        }
    }
    
    func updateTimeStamp() {
        if beatNumber % timeSignature == 0 {
            strongBeatSound?.play()
            beatNumber = 0
            state.beatNumber = 0
        } else {
            weakBeatSound?.play()
        }
        beatNumber += 1
        state.beatNumber += 1
        
    }
    
    func startIntervalTimer() {
        intervalTimer?.invalidate()
        beatNumber = 0
        updateTimeStamp()
        intervalTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.metronomeQueue.sync{
                self.updateTimeStamp()
            }
        }
    }
    
    func stopIntervalTimer() {
        intervalTimer?.invalidate()
    }
}
