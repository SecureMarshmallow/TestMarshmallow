//
//  ScreenViewController.swift
//  TestMarshmallow
//
//  Created by 박준하 on 2023/05/10.
//

import UIKit

class ScreenViewController: UIViewController {

    let screen = UIScreen.main
    let screens = UIScreen.screens
    let slider = UISlider()

    override func viewDidLoad() {
        super.viewDidLoad()

        let bounds = screen.bounds
        print("화면 범위: \(bounds)")

        let nativeBounds = screen.nativeBounds
        print("화면 네이티브 경계: \(nativeBounds)")

        let scale = screen.scale
        print("스크린 스케일: \(scale)")

        let nativeScale = screen.nativeScale
        print("스크린 네이티브 스케일: \(nativeScale)")

        let preferredMode = screen.preferredMode
        print("화면 선호 모드: \(String(describing: preferredMode))")

        let availableModes = screen.availableModes
        print("화면 사용 가능 모드: \(availableModes)")

        let brightness = screen.brightness
        print("화면 밝기: \(brightness)")

        let wantsSoftwareDimming = screen.wantsSoftwareDimming
        print("화면에 소프트웨어 디밍이 필요함: \(wantsSoftwareDimming)")

        let overscanCompensation = screen.overscanCompensation
        print("화면 오버스캔 보정 \(overscanCompensation)")

        // 슬라이더를 생성하고 뷰에 추가합니다.
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = Float(screen.brightness)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        view.addSubview(slider)

        // 슬라이더의 위치를 설정합니다.
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slider.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        slider.widthAnchor.constraint(equalToConstant: 200).isActive = true

    }

    @objc func sliderValueChanged(_ sender: UISlider) {
        screen.brightness = CGFloat(sender.value)
    }
}
//import UIKit
//
//class ScreenViewController: UIViewController {
//
//    let device = UIScreen.main
//
//    let slider = UISlider()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let brightness = UIScreen.main.brightness
//        print("화면 밝기: \(brightness)")
//
//        // 슬라이더를 생성하고 뷰에 추가합니다.
//        slider.minimumValue = 0.0
//        slider.maximumValue = 1.0
//        slider.value = Float(brightness)
//        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
//        view.addSubview(slider)
//
//        // 슬라이더의 위치를 설정합니다.
//        slider.translatesAutoresizingMaskIntoConstraints = false
//        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        slider.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        slider.widthAnchor.constraint(equalToConstant: 200).isActive = true
//
//    }
//
//    @objc func sliderValueChanged(_ sender: UISlider) {
//        UIScreen.main.brightness = CGFloat(sender.value)
//    }
//}
