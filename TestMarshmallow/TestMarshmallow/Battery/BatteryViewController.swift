//
//  BatteryViewController.swift
//  TestMarshmallow
//
//  Created by 박준하 on 2023/05/09.
//

import UIKit

class BatteryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
        print("Low power mode enabled: \(isLowPowerMode)")
        
        // 배터리 정보 가져오기
        let batteryLevel = UIDevice.current.batteryLevel
        let batteryState = UIDevice.current.batteryState
        let batteryLevelPercentage = Int(batteryLevel * 100)
        
        print("배터리 레벨: \(batteryLevelPercentage)%")
        
        let isMonitoring = UIDevice.current.isProximityMonitoringEnabled
        print("근접 모니터링 사용: \(isMonitoring)")
    
        
        switch batteryState {
        case .unknown:
            print("배터리 상태: unknown")
        case .unplugged:
            print("배터리 상태: unplugged")
        case .charging:
            print("배터리 상태: charging")
        case .full:
            print("배터리 상태: full")
        @unknown default:
            fatalError()
        }
        
        let battery = UIDevice.current
        
        // 배터리 관련 알림 받기
        NotificationCenter.default.addObserver(forName: UIDevice.batteryLevelDidChangeNotification, object: battery, queue: nil) { (notification) in
            let batteryLevel = UIDevice.current.batteryLevel
            print("배터리 레벨이 변경됨: \(batteryLevel)")
        }
        
        NotificationCenter.default.addObserver(forName: UIDevice.batteryStateDidChangeNotification, object: battery, queue: nil) { (notification) in
            let batteryState = UIDevice.current.batteryState
            switch batteryState {
            case .unknown:
                print("배터리 상태가 변경됨: unknown")
            case .unplugged:
                print("배터리 상태가 변경됨: unplugged")
            case .charging:
                print("배터리 상태가 변경됨: charging")
            case .full:
                print("배터리 상태가 변경됨: full")
            @unknown default:
                fatalError()
            }
        }
    }
}
