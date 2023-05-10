////
////  ViewController.swift
////  TestMarshmallow
////
////  Created by 박준하 on 2023/05/10.
////
//
//import UIKit
//import SnapKit
//
//class ViewController: UIViewController {
//
//    var collectionView: UICollectionView!
//
//    var items: [Int] = [1, 2, 3, 4, 5]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Create collectionView layout
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 10
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        view.addSubview(collectionView)
//
//        // Set constraints using SnapKit
//        collectionView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(100)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//            make.bottom.equalToSuperview().offset(-100)
//        }
//
//        // Register cell classes
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//    }
//
//}
//
//// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
//extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = .gray
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let item = items[indexPath.item]
//        switch item {
//        case 1:
//            return CGSize(width: 80, height: 80)
//        case 2:
//            return CGSize(width: 370, height: 230)
//        case 3:
//            return CGSize(width: 370, height: 260)
//        case 4:
//            return CGSize(width: 150, height: 150)
//        case 5:
//            return CGSize(width: 370, height: 370)
//        default:
//            return CGSize(width: 100, height: 100)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        let item = items[indexPath.item]
//        return item == 1 || item == 4
//    }
//
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let sourceItem = items[sourceIndexPath.item]
//        let destinationItem = items[destinationIndexPath.item]
//        if sourceItem == 4 && destinationItem == 1 {
//            // swap items
//            items.swapAt(sourceIndexPath.item, destinationIndexPath.item)
//            collectionView.reloadData()
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
//        let proposedItem = items[proposedIndexPath.item]
//        if proposedItem == 5 || proposedItem == 3 {
//            // Don't allow horizontal movement
//            return originalIndexPath
//        } else {
//            return proposedIndexPath
//        }
//    }
//}
import UIKit
import SnapKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var items: [[Int]] = [
        [2],
        [1,1,1,1],
        [3],
        [4, 4],
        [5],
    ]
    
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Add LongPressGesture Recognizer to the collection view
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .gray
        
        let item = items[indexPath.section][indexPath.item]
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Item \(item)"
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.section < items.count, indexPath.item < items[indexPath.section].count else {
            return .zero
        }
        
        let item = items[indexPath.section][indexPath.item]
        switch item {
        case 1:
            return CGSize(width: 80, height: 80)
        case 2:
            return CGSize(width: 370, height: 230)
        case 3:
            return CGSize(width: 370, height: 260)
        case 4:
            return CGSize(width: 150, height: 150)
        case 5:
            return CGSize(width: 370, height: 370)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}

extension ViewController {
    func createHeaderLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }
    
    func createFooterView() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.section][indexPath.item]
        print("Selected item: \(item)")
        print(items)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        // 이동 가능한 셀인지 여부를 반환
        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 이동할 셀의 현재 위치와 새로운 위치를 나타내는 인덱스를 받아옴
        // 데이터 모델에서 해당 위치의 데이터를 이동시키고, 셀의 위치를 업데이트함
        let item = items[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        items[destinationIndexPath.section].insert(item, at: destinationIndexPath.item)
        print(items)
    }
}
