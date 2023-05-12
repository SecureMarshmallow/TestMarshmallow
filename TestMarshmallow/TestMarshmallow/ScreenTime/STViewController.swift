//
//  STViewController.swift
//  TestMarshmallow
//
//  Created by 박준하 on 2023/05/10.
//

import UIKit
import ScreenTime

class STViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenTime = STScreenTime()
        switch screenTimeAuthorizationStatus {
        case .authorized:
            // 스크린 타임 권한이 허용됨
        case .denied:
            // 스크린 타임 권한이 거부됨
        case .restricted:
            // 스크린 타임이 제한됨
        case .notDetermined:
            // 스크린 타임 권한이 아직 요청되지 않음
            STAuthorizationManager.requestScreenTimeAuthorization { (status) in
                if status == .authorized {
                    // 스크린 타임 권한이 허용됨
                } else {
                    // 스크린 타임 권한이 거부됨
                }
            }
        @unknown default:
            break
        }
        
    }
}
