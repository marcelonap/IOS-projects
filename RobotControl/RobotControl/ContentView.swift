//
//  ContentView.swift
//  RobotControl
//
//  Created by Marcelo Napoleao Sampaio on 2023-12-15.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var sliderValue: Double = 0
    @ObservedObject private var bluetoothManager = BluetoothManager()
    
    var body: some View {
        VStack {
            Spacer()

            // Directional Buttons with Arrow Shapes
            HStack {
                Spacer()

                VStack {
                    Button(action: {
                        // Action for Up Button
                        bluetoothManager.writeToRobot("@MF0")
                    }) {
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            // Action for Left Button
                            bluetoothManager.writeToRobot("@ML0")
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        Spacer()
                        Button(action: {
                            bluetoothManager.writeToRobot("@MR0")
                        }) {
                            Image(systemName: "arrow.right")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        Spacer()
                    }
                    
                    Button(action: {
                        // Action for Down Button
                        bluetoothManager.writeToRobot("@MB0")
                    }) {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }

                Spacer()
            }

            Spacer()

            // Slider
            Slider(value: $sliderValue, in: 0...100) {
                Text("Slider")
            }
            .padding()

            // Utility Button
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
                      }
                      
                      Spacer()
                  }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

