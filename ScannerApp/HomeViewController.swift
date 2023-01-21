//
//  ViewController.swift
//  ScannerApp
//
//  Created by Hiago Santos Martins Dias on 21/01/23.
//

import CoreBluetooth
import UIKit

struct DiscoveredDevice {
    var name: String
    var uuid: String
    var rssi: String
}

class HomeViewController: UIViewController {
    
    var centralManager: CBCentralManager!
    @IBOutlet weak var scanButton: UIButton!
    
    @IBOutlet weak var homeTableView: UITableView!
    var discoveredDevices = [DiscoveredDevice]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        
    }
    
    @IBAction func scanButtonTapped(_ sender: Any) {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }


}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredDevices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        let device = discoveredDevices[indexPath.row]

        cell.textLabel?.text = device.name
        cell.detailTextLabel?.text = "UUID: \(device.uuid) RSSI: \(device.rssi)"
        return cell
    }
    
}

extension HomeViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
        @unknown default:
            print("ERROR")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Extract the peripheral's name and other relevant information from the advertisement data
        let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? "Unknown"
        let uuid = peripheral.identifier.uuidString
        let rssi = RSSI.stringValue

        // Add the peripheral to an array of discovered devices
        discoveredDevices.append(DiscoveredDevice(name: name, uuid: uuid, rssi: rssi))
        homeTableView.reloadData()
    }
    
    
    
    
}
