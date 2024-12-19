//
//  ContentView.swift
//  TestPreviewArchitecture
//
//  The goal of this project is to test different approaches to state propagation when following a MVVM architecture, that allow for testability (previewablity), scalability and maintainability.
//  The inspiration for this project is the Android Jetpack compose architecture followed in the Agra-Toolbox app, which I would ideally like to replicate for iOS with swiftUI, as it has been suiting my preview and scaling needs efficiently.
//  Created by Marcelo Napoleao Sampaio on 2024-12-18.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: UiStateViewModel
    
    var body: some View {
        VStack {
            //MetronomeViewBad()
            Spacer()
//            Text("Bindings")
//            MetronomeViewFix(
//                bpm: $viewModel.metronomeManager.bpm,
//                isPlaying: $viewModel.isPlaying,
//                timeSignature: $viewModel.metronomeManager.timeSignature,
//                beats: $viewModel.metronomeManager.beats,
//                togglePlay: {
//                    Task{
//                        viewModel.onMetronomeToggle()
//                    }
//                }
//            )
            //Spacer()
            //Text("State Objects")
            MetronomeRoot(viewModel: MetronomeViewModel(metronomeManager: viewModel.metronomeManager))
            Spacer()
        }
        .onChange(of: viewModel.metronomeManager.isPlaying){ newValue in
            print(" parent view  Isplaying changed to: \(newValue)")
        }
        .padding()
    }
}




struct MetronomeViewFixTwo{
    
    var body: some View{
        VStack{
            
        }
        
    }
}

struct MetronomeViewFix: View{
    
    @Binding var bpm: Double
    @Binding var isPlaying: Bool
    @Binding var timeSignature: Int
    @Binding var beats: [Int]
    
    var togglePlay: () -> Void
    
    
    var body: some View {
        VStack(spacing: 24) {
            // BPM Display and Control
            VStack {
                Text("\(Int(bpm))")
                    .font(.system(size: 48, weight: .bold))
                HStack {
                    Button(action: { bpm -= 1}) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                    }
                    Slider(
                        value: $bpm,
                        in: 40...240,
                        step: 1
                    )
                    .frame(maxWidth: 200)
                    Button(action: { bpm += 1 }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
            }
            
            HStack {
                Text("Time Signature:")
                Picker("Time Signature", selection: $timeSignature) {
                    ForEach(beats, id: \.self) { beats in
                        Text("\(beats)/4").tag(beats)
                    }
                    
                }
                .pickerStyle(.menu)
            }
            
            Button(action: togglePlay) {
                Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(isPlaying ? .red : .green)
            }
        }
        .padding()
        .onChange(of: isPlaying){ newValue in
            print(" child view  Isplaying changed to: \(newValue)")
                //isPlaying = newValue
        }
    }
}



struct MetronomeViewBad: View {
    @EnvironmentObject var viewModel: UiStateViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            // BPM Display and Control
            VStack {
                Text("\(Int(viewModel.metronomeManager.bpm))")
                    .font(.system(size: 48, weight: .bold))
                
                HStack {
                    Button(action: { viewModel.metronomeManager.decrementBpm()}) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                    }
                    
                    Slider(
                        value: $viewModel.metronomeManager.bpm,
                        in: 40...240,
                        step: 1
                    )
                    .frame(maxWidth: 200)
                    
                    Button(action: { viewModel.metronomeManager.incrementBpm() }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
            }
            
            HStack {
                Text("Time Signature:")
                Picker("Time Signature", selection: $viewModel.metronomeManager.timeSignature) {
                    ForEach(viewModel.metronomeManager.beats, id: \.self) { beats in
                        Text("\(beats)/4").tag(beats)
                    }
                  
                }
                .pickerStyle(.menu)
            }
            
            Button(action: {viewModel.metronomeManager.toggleMetronome()}) {
                Image(systemName: $viewModel.metronomeManager.isPlaying.wrappedValue ? "stop.circle.fill" : "play.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor($viewModel.metronomeManager.isPlaying.wrappedValue ? .red : .green)
            }
        }
        .padding()
    }
    
   
   
}

// Preview with mock data
#Preview {
    MetronomeViewBad()
        .environmentObject(UiStateViewModel(metronomeManager: MetronomeManager()))
}


#Preview{
    
    MetronomeViewFix(
        bpm: .constant(120),
        isPlaying: .constant(false),
        timeSignature: .constant(4),
        beats: .constant([2,3,4,5,6,7,8]),
        togglePlay: {}
    )
}


#Preview {
    ContentView()
        .environmentObject(UiStateViewModel(metronomeManager: MetronomeManager()))

}
