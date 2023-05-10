//
//  OSViewController.swift
//  TestMarshmallow
//
//  Created by 박준하 on 2023/05/10.
//

import UIKit

class OSViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let device = UIDevice.current

        let deviceName = device.name
        print("Device name: \(deviceName)")

        let systemName = device.systemName
        print("System name: \(systemName)")

        let systemVersion = device.systemVersion
        print("System version: \(systemVersion)")

        let model = device.model
        print("Device model: \(model)")

        let localizedModel = device.localizedModel
        print("Localized model: \(localizedModel)")

        let uuid = device.identifierForVendor?.uuidString ?? "Unknown"
        print("Device UUID: \(uuid)")
        
    }
}
