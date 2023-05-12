//
//  aViewController.swift
//  TestMarshmallow
//
//  Created by 박준하 on 2023/05/10.
//

import UIKit

class aViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let blockedAppIds = ["com.example.blockedapp1", "com.example.blockedapp2"]
        
        var blockTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
        
        blockTaskIdentifier = UIApplication.shared.beginBackgroundTask(withName: "Block App") {
            // 앱 차단 시간이 만료되었을 때 실행되는 코드
            UIApplication.shared.endBackgroundTask(blockTaskIdentifier)
            blockTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        }
        
        // 앱 차단 기능 실행
        // ...
        
        // 앱 차단이 끝나면 아래 코드를 실행하여 백그라운드 작업을 종료합니다.
        UIApplication.shared.endBackgroundTask(blockTaskIdentifier)
        blockTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    }
}
