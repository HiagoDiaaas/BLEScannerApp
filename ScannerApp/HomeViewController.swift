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
    var date: String
}

class HomeViewController: UIViewController {
    
    var centralManager: CBCentralManager!
    @IBOutlet weak var scanButton: UIButton!
    
    @IBOutlet weak var homeTableView: UITableView!
    var discoveredDevices = [DiscoveredDevice]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        customTableView()
    }
    
    private func customTableView() {
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                      bundle: nil)
        self.homeTableView.register(textFieldCell,
                                    forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    @IBAction func scanButtonTapped(_ sender: Any) {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    


}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeripheral = discoveredDevices[indexPath.row]
            performSegue(withIdentifier: "ShowSegueDetail", sender: selectedPeripheral)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredDevices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell {
            let device = discoveredDevices[indexPath.row]
            
            print("Hello")
            cell.nameLabel.text = device.name
            cell.rssiLabel.text = device.rssi
            cell.dateLabel.text = device.date
            
            return cell
        }
        
        return UITableViewCell()
        
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
        let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? advertisementData[CBAdvertisementDataManufacturerDataKey] as? String ?? "Unknown"
        let uuid = peripheral.identifier.uuidString
        let rssi = RSSI.stringValue
        
        // Get the current date and time
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        // Add the peripheral to an array of discovered devices
        discoveredDevices.append(DiscoveredDevice(name: name, uuid: uuid, rssi: rssi, date: dateString))
        homeTableView.reloadData()
    }
    
    
    
    
}
