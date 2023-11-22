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
        VStack{
            Button("Scan devices"){
                bluetoothManager.central.scanForPeripherals(withServices: nil, options: nil)
            }
            
            Text(bluetoothManager.payload)
            
            if bluetoothManager.device == nil{
                List(bluetoothManager.peripherals, id: \.self) { peripheral in
                    if peripheral.name != nil{
                        // if peripheral.name!.contains("AGRA"){
                        Button(peripheral.name!){
                            bluetoothManager.central.connect(peripheral)
                            //   }
                        }
                    }
                }
            } else {
                Button("send echo"){
                    bluetoothManager.writeToRx("$ECHOBT,1\r\n")
                  
                    
                }
            }
            Spacer()
        }
        
    }
}

#Preview {
    ContentView()
}
