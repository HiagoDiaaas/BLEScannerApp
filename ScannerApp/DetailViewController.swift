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
    var selectedPeripheral: CBPeripheral!
    var centralManager: CBCentralManager!

    var heartRateDeviceService = CBUUID(string: "0x180A")
    var modelNumberStringCharacteristicCBUUID = CBUUID(string: "2A24")
    var manufacturerNameStringCBUUID = CBUUID(string: "2A29")

    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        centralManager = CBCentralManager(delegate: self, queue: nil)
        modelLabel.isHidden = true
        manufacturerLabel.isHidden = true
    }
}

extension DetailViewController: CBCentralManagerDelegate, CBPeripheralDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [heartRateDeviceService])
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        selectedPeripheral = peripheral
        selectedPeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(selectedPeripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        peripheral.discoverServices([heartRateDeviceService])
        
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            if characteristic.uuid == modelNumberStringCharacteristicCBUUID {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.uuid == manufacturerNameStringCBUUID {
                peripheral.readValue(for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == modelNumberStringCharacteristicCBUUID {
            if let model = characteristic.value {
                self.modelLabel.text = String(data: model, encoding: .utf8)
                modelLabel.isHidden = false
            }
        }
        if characteristic.uuid == manufacturerNameStringCBUUID {
            if let manufacturer = characteristic.value {
                self.manufacturerLabel.text = String(data: manufacturer, encoding: .utf8)
                manufacturerLabel.isHidden = false
            }
        }
    }

}
