//
//  ViewController.swift
//  TestMarshmallow
//
//  Created by 박준하 on 2023/05/09.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import CoreTelephony


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //네트워크 SSID와 BSSID
        let wifiInfo = getCurrentWiFiInfo()
        
        //현재 연결된 Wi-Fi 네트워크의 이름
        print("SSID: \(wifiInfo.ssid ?? "Unknown SSID")")
        
        //현재 연결된 Wi-Fi 네트워크의 MAC 주소
        print("BSSID: \(wifiInfo.bssid ?? "Unknown BSSID")")
        
        let vpnManager = NEVPNManager.shared()
        if let protocolConfiguration = vpnManager.protocolConfiguration, let serverAddress = protocolConfiguration.serverAddress {
            print("주소로 VPN 서버에 연결됨: \(serverAddress)")
        } else {
            print("현재 설정된 VPN 연결이 없습니다.")
        }
        
        let cellularInfo = getCellularInfo()
        if let carrierName = cellularInfo.carrierName {
            print("통신사 이름: \(carrierName)")
        } else {
            print("이동통신사 이름을 검색할 수 없습니다..")
        }

        if let technology = cellularInfo.technology {
            print("현재 셀룰러 기술: \(technology)")
        } else {
            print("셀룰러 기술을 검색할 수 없습니다.")
        }
        
        view.backgroundColor = .red
    }
    
    func getCurrentWiFiInfo() -> (ssid: String?, bssid: String?) {
        guard let interfaceList = CNCopySupportedInterfaces() as NSArray?,
              let interfaceName = interfaceList.firstObject as? String,
              let networkInfo = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary?,
              let ssid = networkInfo[kCNNetworkInfoKeySSID as String] as? String,
              let bssid = networkInfo[kCNNetworkInfoKeyBSSID as String] as? String
        else {
            return (nil, nil)
        }
        
        return (ssid, bssid)
    }
    
    func getCellularInfo() -> (carrierName: String?, technology: String?) {
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.serviceSubscriberCellularProviders?.values.first {
            let carrierName = carrier.carrierName
            let technology = networkInfo.serviceCurrentRadioAccessTechnology?.first?.value
            return (carrierName, technology)
        }
        return (nil, nil)
    }
    
}

