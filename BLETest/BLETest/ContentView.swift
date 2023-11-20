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

    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            central.scanForPeripherals(withServices: nil, options: nil)
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
}

struct ContentView: View {
    @ObservedObject private var bluetoothManager = BluetoothManager()

    var body: some View {
        List(bluetoothManager.peripherals, id: \.self) { peripheral in
            Text(peripheral.name ?? "Unknown Device")
        }
    }
}

#Preview {
    ContentView()
}
