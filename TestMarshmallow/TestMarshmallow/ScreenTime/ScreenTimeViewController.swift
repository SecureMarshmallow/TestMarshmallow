//
//  ScreenTimeViewController.swift
//  TestMarshmallow
//
//  Created by 박준하 on 2023/05/10.
//

import UIKit
import ScreenTime

class ScreenTimeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webpageController = STWebpageController()

        webpageController.fetchWebUsage(for: .yesterday) { (webUsage, error) in
            if let error = error {
                print("Error fetching web usage: \(error)")
                return
            }
            
            if let webUsage = webUsage {
                print("Yesterday's web usage: \(webUsage)")
            } else {
                print("No web usage data available.")
            }
        }


    }
}
