//
//  Terminalview.swift
//  MusicTerminal
//
//  Created by Marcelo Napoleao Sampaio on 2024-02-04.
//
import SwiftUI
import Combine

struct TerminalView: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    @State private var inputText: String = ""
    @State private var messages: [String] = []
    @State private var scrollToBottom = false
    @State private var cancellables: Set<AnyCancellable> = []
    @State private var lineNum : Int = 0

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    ForEach(Array(messages.enumerated()), id: \.element) { index, message in
                        Text("\(lineNum + 1): \(message)")
                            .multilineTextAlignment(.leading)
                            .padding()
                            .id(index)
                    }
                }
                .onChange(of: messages.count) { _ in
                    scrollToBottom = true
                    lineNum += 1
                }
                .onAppear {
                    scrollToBottom = true
                }
                .onChange(of: scrollToBottom) { _ in
                    if scrollToBottom {
                        withAnimation {
                            scrollViewProxy.scrollTo(messages.count - 1, anchor: .bottom)
                        }
                        scrollToBottom = false
                    }
                }
            }

            HStack {
                TextField("Type your message here...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Send") {
                    sendMessage()
                }
                
                Button("Send Test"){
                    print(bluetoothManager.device?.name)
                   _ = bluetoothManager.writeToRx("testing, hi from app \n\r")
                }
            }
            .padding()
        }
        .onAppear(perform: setup)
        .navigationTitle("BLE Terminal")
    }

    private func setup() {
        // Observe incoming messages
        bluetoothManager.$payload
            .receive(on: DispatchQueue.main)
            .sink { payload in
                if !payload.isEmpty {
                    self.messages.append("Received: \(payload)")
                }
            }
            .store(in: &cancellables)
    }

    private func sendMessage() {
        let success = bluetoothManager.writeToRx("\(inputText)\r\n")
        if success {
            messages.append("Sent: \(inputText)")
            inputText = ""
        } else {
            print("Failed to send message")
        }
    }
}

#Preview {
    TerminalView()
        .environmentObject(BluetoothManager())
}
