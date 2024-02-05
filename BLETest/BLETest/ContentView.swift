//
//  ContentView.swift
//  BLETest
//
//  Created by Marcelo Napoleao Sampaio on 2023-11-19.
//
import SwiftUI


struct ContentView: View {
    @ObservedObject private var bluetoothManager = BluetoothManager()

    var body: some View {
        NavigationView {
            VStack {
                Button("Scan Devices") {
                    bluetoothManager.central.scanForPeripherals(withServices: nil, options: nil)
                }
                .buttonStyle(.borderedProminent)
                .padding()

                if bluetoothManager.device == nil {
                    List(bluetoothManager.peripherals, id: \.self) { peripheral in
                        if let name = peripheral.name {
                            Button(name) {
                                bluetoothManager.central.connect(peripheral)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                } else {
                    Button("Send Echo") {
                        _ = bluetoothManager.writeToRx("$ECHOBT,1\r\n")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }

                Spacer()

                // Navigation to Login Screen
                NavigationLink("Go to Login", destination: LoginView())

                Spacer()
            }
            .navigationTitle("Welcome")
        }
    }
}


#Preview {
    ContentView()
}
