//
//  UsageLimitViewController.swift
//  TestMarshmallow
//
//  Created by 박준하 on 2023/05/10.
//
import UIKit
import ScreenTime

class UsageLimitViewController: UIViewController {
    
    
    let screenTime = STScreenTime()
    var remainingTime: TimeInterval = 0
    
    lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRemainingTime()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(remainingTimeLabel)
        NSLayoutConstraint.activate([
            remainingTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            remainingTimeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            remainingTimeLabel.widthAnchor.constraint(equalToConstant: 200),
            remainingTimeLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateRemainingTime() {
        let appUsageLimit = screenTime.usageLimit(for: .mostRecent, during: .today)
        if let limit = appUsageLimit?.limit {
            remainingTime = limit - screenTime.usageTime(for: .mostRecent, during: .today)
            if remainingTime <= 0 {
                remainingTimeLabel.text = "사용 가능 시간이 초과되었습니다."
            } else {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute]
                formatter.unitsStyle = .abbreviated
                let formattedString = formatter.string(from: remainingTime)!
                remainingTimeLabel.text = "남은 사용 가능 시간: \(formattedString)"
            }
        }
    }
}
