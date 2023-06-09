//
//  BaseSC.swift
//  TestMarshmallow
//
//  Created by 박준하 on 2023/05/22.
//

import UIKit
import Then
import SnapKit

class BaseSC<T>: UICollectionViewCell {
    
    internal let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .systemBlue
    }
    
    internal let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textColor = .white
    }
    
    internal let switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = .systemGreen
        switchControl.isHidden = true
        return switchControl
    }()
    
    internal lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, UIView(), switchControl])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: T) { }
}
