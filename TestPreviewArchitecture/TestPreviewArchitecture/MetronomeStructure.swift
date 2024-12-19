import Foundation
import AVFoundation
import SwiftUI

// Root view that connects everything
struct MetronomeRoot: View {
    @StateObject private var viewModel: MetronomeViewModel
    
    init(viewModel: MetronomeViewModel ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        MetronomeView(
            state: viewModel.state,
            events: viewModel.events
        )
    }
}

// UI View that takes state and events
struct MetronomeView: View {
    let state: MetronomeState
    let events: MetronomeEvents
    
    var body: some View {
        VStack(spacing: 24) {
            // BPM Display and Control
            VStack {
                Text("\(Int(state.bpm))")
                    .font(.system(size: 48, weight: .bold))
                
                Text("\(state.beatNumber)/\(state.timeSignature)")
                HStack {
                    Button(action: { events.onBpmChanged(state.bpm - 1) }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                    }
                    
                    Slider(
                        value: Binding(
                            get: { state.bpm },
                            set: { events.onBpmChanged($0) }
                        ),
                        in: 40...240,
                        step: 1
                    )
                    .frame(maxWidth: 200)
                    
                    Button(action: { events.onBpmChanged(state.bpm + 1) }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
            }
            
            HStack {
                Text("Time Signature:")
                Picker("Time Signature", selection: Binding(
                    get: { state.timeSignature },
                    set: { events.onTimeSignatureChanged($0) }
                )) {
                    ForEach(state.beats, id: \.self) { beats in
                        Text("\(beats)/4").tag(beats)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Button(action: events.onPlayToggled) {
                Image(systemName: state.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(state.isPlaying ? .red : .green)
            }
        }
        .padding()
    }
}


// Preview with different states
struct MetronomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Default state preview
            MetronomeRoot(viewModel: MetronomeViewModel(metronomeManager: MetronomeManager()))
                .previewDisplayName("Fully loaded")
            
            MetronomeView(
                state: .initial,
                events: .preview
            )
            .previewDisplayName("Default State")
            
            // Playing state preview
            MetronomeView(
                state: MetronomeState(
                    bpm: 160,
                    timeSignature: 3,
                    isPlaying: true,
                    beats: [2, 3, 4, 6, 8],
                    beatNumber: 1
                ),
                events: .preview
            )
            .previewDisplayName("Playing State")
        }
    }
}
