//
//  ContentView.swift
//  BLETest
//
//  Created by Marcelo Napoleao Sampaio on 2023-11-19.
//

import SwiftUI
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    @Published var peripherals: [CBPeripheral] = []

    private var centralManager: CBCentralManager!
    
    @Published var canScan: Bool = false
    
    let txUART : String = "49535343-1e4d-4bd9-ba61-23c647249616"
    
    let rxUART : String = "49535343-8841-43f4-a8d4-ecbe34729bb3"
    
    var central : CBCentralManager {
        centralManager
    }

    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
           // central.scanForPeripherals(withServices: nil, options: nil)
            canScan = true
        default:
            print("Bluetooth is not available.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // Check if the peripheral is not already in the list
        if !peripherals.contains(peripheral) {
            peripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // You are now connected to the peripheral
        // Perform additional tasks such as discovering services and characteristics
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
           // Handle the discovery of services
           guard let services = peripheral.services else { return }

           for service in services {
               // Discover characteristics for each service
               peripheral.discoverCharacteristics(nil, for: service)
           }
       }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            // Handle the discovery of characteristics
            guard let characteristics = service.characteristics else { return }

            for characteristic in characteristics {
                // Subscribe to notifications for the desired characteristic
                if characteristic.uuid.uuidString == txUART {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral. Error: \(error?.localizedDescription ?? "Unknown error")")
    }
}

struct ContentView: View {
    @ObservedObject private var bluetoothManager = BluetoothManager()

    var body: some View {
        if bluetoothManager.canScan {
            Button("Scan devices"){
                bluetoothManager.central.scanForPeripherals(withServices: nil, options: nil)
            }
        }
        
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
}

#Preview {
    ContentView()
}
