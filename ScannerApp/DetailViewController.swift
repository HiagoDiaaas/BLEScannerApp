//
//  DetailViewController.swift
//  ScannerApp
//
//  Created by Hiago Santos Martins Dias on 27/01/23.
//

import CoreBluetooth
import UIKit

class DetailViewController: UIViewController {

    var device: DiscoveredDevice!
    var peripheral: CBPeripheral!
    var centralManager: CBCentralManager!

    let heartRateDeviceService = CBUUID(string: "0x180A")
    let modelNumberStringCharacteristicCBUUID = CBUUID(string: "2A24")
    let manufacturerNameStringCBUUID = CBUUID(string: "2A29")

    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        centralManager = CBCentralManager(delegate: self, queue: nil)

        // Connect to the selected peripheral
        guard let peripheral = peripheral else { return }
        centralManager.connect(peripheral, options: nil)


        // Discover services of the selected peripheral
        peripheral.discoverServices(nil)

        peripheral.delegate = self
    }
}

extension DetailViewController: CBCentralManagerDelegate, CBPeripheralDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("central.state is .poweredOn")
            self.centralManager.connect(peripheral, options: nil)
        default:
            break
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            if characteristic.uuid == modelNumberStringCharacteristicCBUUID {
                peripheral.readValue(for: characteristic)
            } else if characteristic.uuid == manufacturerNameStringCBUUID {
                peripheral.readValue(for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == modelNumberStringCharacteristicCBUUID {
            if let model = characteristic.value {
                self.modelLabel.text = String(data: model, encoding: .utf8)
            }
        }
        if characteristic.uuid == manufacturerNameStringCBUUID {
            if let manufacturer = characteristic.value {
                self.manufacturerLabel.text = String(data: manufacturer, encoding: .utf8)
            }
        }
    }
    
    

}
