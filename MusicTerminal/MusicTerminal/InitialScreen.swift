//
//  InitialScreen.swift
//  MusicTerminal
//
//  Created by Marcelo Napoleao Sampaio on 2024-02-04.
//


import SwiftUI


struct InitialView: View {
    
    @EnvironmentObject private var bluetoothManager: BluetoothManager
    
    var body: some View {
        NavigationView {
            VStack {
               
                
                    if bluetoothManager.device == nil{
                        Button("Scan Devices") {
                            bluetoothManager.central.scanForPeripherals(withServices: nil, options: nil)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        List(bluetoothManager.peripherals, id: \.self) { peripheral in
                            if let name = peripheral.name{
                                Button(name) {
                                    bluetoothManager.central.connect(peripheral)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    } else {
                       TerminalView()
                            .environmentObject(bluetoothManager)
                    }
                

                Spacer()

                // Navigation to Login Screen
               
                    
        

                Spacer()
            }
            .navigationTitle("Welcome")
           
        }
        .onDisappear(perform: {
            bluetoothManager.central.stopScan()
        })
        .onAppear(perform: {
        })
    }
}


#Preview {
    InitialView()
}
