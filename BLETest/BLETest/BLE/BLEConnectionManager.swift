//
//  BLEConnectionManager.swift
//  BLETest
//
//  Created by Marcelo Napoleao Sampaio on 2023-11-22.
//

import Foundation
import SwiftUI
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var peripherals: [CBPeripheral] = []

    private var centralManager: CBCentralManager!
    
    @Published var payload: String = ""
    
    @Published var canScan: Bool = false
    
    let txUART : String = "49535343-1E4D-4BD9-BA61-23C647249616"
    
    let rxUART : String = "49535343-8841-43F4-A8D4-ECBE34729BB3"
    
    let TUART : String = "49535343-FE7D-4AE5-8FA9-9FAFD205E455"
    
    var rx: CBCharacteristic?
    
    var device : CBPeripheral?
    
    
    
    var central : CBCentralManager {
        centralManager
    }

    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: "com.ios.agragps"])
    }
    
    func writeToRx(_ message : String) ->  Bool {
        guard let characteristic = rx else {return false}
        guard let peripheral = device else {return false}
        guard let data = message.data(using: .utf8) else {return false}
        
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
        return true
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        // Check for peripherals that were connected before
        if let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] {
            for peripheral in peripherals {
                // Reconnect to the peripheral
                central.connect(peripheral, options: nil)
            }
        }
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
        print("connected, attemptingto discover services")
        peripheral.delegate = self
        device = peripheral
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // Handle the discovery of services
        print("discovering services")
        guard error == nil, let services = peripheral.services else {
            if let error = error {
                print("Error discovering services: \(error.localizedDescription)")
            }
            return
        }
        
        for service in services {
            print(service.uuid.uuidString)
            print(service.uuid.uuidString == TUART)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            // Handle the discovery of characteristics
            guard let characteristics = service.characteristics else { return }
            print("discovering characteristics")
            for characteristic in characteristics {
                print(characteristic.uuid.uuidString)
                if characteristic.uuid.uuidString == rxUART{
                    rx = characteristic
                }
                // Subscribe to notifications for the desired characteristic
                if characteristic.uuid.uuidString == txUART {
                    print("tx found")
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }

        }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral. Error: \(error?.localizedDescription ?? "Unknown error")")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // Handle the updated value of the characteristic
        if let data = characteristic.value {
//            var msg : String = ""
//            for char in  data.base64EncodedString(){
//                var num : Int = char
//                msg += num as Charecter
//            }
            let encodedString = data.base64EncodedString()

            // Decode the Base64 string
            if let data = Data(base64Encoded: encodedString) {
                // Convert the data to a readable string
                if let decodedString = String(data: data, encoding: .utf8) {
                    print("Decoded String: \(decodedString)")
                    payload = decodedString
                } else {
                    print("Failed to convert data to string.")
                }
            } else {
                print("Failed to decode Base64 string.")
            }
        }
    }
}
