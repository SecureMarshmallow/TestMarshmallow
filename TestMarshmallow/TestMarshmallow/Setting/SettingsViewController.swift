//
//  SettingsViewController.swift
//  TestMarshmallow
//
//  Created by 박준하 on 2023/05/22.
//

import UIKit
import Then

class SettingsViewController: BaseSV {

    // MARK: - Properties
    
    private var settingsItems: [[SettingsItem]] = []
    
    private lazy var navLabel = UILabel().then {
        $0.textColor = UIColor.black
        $0.text = "설정"
        $0.font = .systemFont(ofSize: 24.0, weight: .bold)
    }
    

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSettingsItems()
    }

    // MARK: - Helpers

    override func configureUI() {
        super.configureUI()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: navLabel)
        self.navigationItem.leftItemsSupplementBackButton = true
    }

    override func configureItems() {
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: SettingsCell.reuseIdentifier)
    }

    private func configureSettingsItems() {
        let section1 = [SettingsItem(type: .gmailInformation),
                        SettingsItem(type: .idInformation)]
        
        let section2 = [SettingsItem(type: .appPassword),
                        SettingsItem(type: .intrusionInformation),
                        SettingsItem(type: .appTracking)]

        let section3 = [SettingsItem(type: .changeAppIcon),
                        SettingsItem(type: .changeAppTheme)]

        let section4 = [SettingsItem(type: .help),
                        SettingsItem(type: .bugReport)]

        let section5 = [SettingsItem(type: .feedback)]

        let section6 = [SettingsItem(type: .appShare),
                        SettingsItem(type: .privacyPolicy),
                        SettingsItem(type: .termsofUse)]

        let section7 = [SettingsItem(type: .howToUse),
                        SettingsItem(type: .developerIformation)]

        settingsItems = [section1, section2, section3, section4, section5, section6, section7]
    }
}

// MARK: - UICollectionViewDataSource

extension SettingsViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return settingsItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingsItems[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as? SettingsCell else {
            fatalError("Failed to dequeue SettingsCell")
        }
        
        let item = settingsItems[indexPath.section][indexPath.item]
        cell.configure(with: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let topInset: CGFloat = 10.0
        let bottomInset: CGFloat = 10.0
        let leftInset: CGFloat = 20.0
        let rightInset: CGFloat = 20.0
        let sectionSpacing: CGFloat = 30.0

        if section == 0 {
            return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        } else {
            return UIEdgeInsets(top: topInset + sectionSpacing, left: leftInset, bottom: bottomInset, right: rightInset)
        }
    }


}

// MARK: - UICollectionViewDelegate

extension SettingsViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)

        let item = settingsItems[indexPath.section][indexPath.item]
        switch item.type {
        case .gmailInformation:
            print("gmail")
        case .idInformation:
            print("id")
        case .intrusionInformation:
            break
        case .appPassword:
            break
        case .appTracking:
            print("time")
        case .changeAppIcon:
            print("앱 아이콘 변경")
        case .changeAppTheme:
            print("앱 테마 변경 클릭")
        case .help:
            print("help")
            print("지원")
        case .bugReport:
            print("버그 제보")
        case .feedback:
            print("피드백")
        case .appShare:
            print("앱 공유")
        case .privacyPolicy:
            print("개인정보 처리 방침")
        case .termsofUse:
            print("이용 약관 클릭")
        case .howToUse:
            print("사용 방법")
        case .developerIformation:
            print("개발자 정보")
        }
    }

}

extension SettingsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
        let itemHeight: CGFloat = 50.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
