//
//  DetailViewController.swift
//  ScannerApp
//
//  Created by Hiago Santos Martins Dias on 27/01/23.
//

import CoreBluetooth
import UIKit

class DetailViewController: UIViewController {
    var selectedPeripheral: CBPeripheral?
    var modelNumber: String?
    var manufacturerName: String?
    var centralManager: CBCentralManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}




