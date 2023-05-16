import UIKit
import SnapKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var items: [[Int]] = [
        [2],
        [1,1,1,1,1,1,1,1],
        [3],
        [4, 4],
        [5],
    ]
    
    let cellIdentifier = "cell"
    var movingCellSnapshot: UIView?
    
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
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
            
            let cell = collectionView.cellForItem(at: selectedIndexPath)!
            
            movingCellSnapshot = cell.snapshotView(afterScreenUpdates: false)
            movingCellSnapshot?.center = cell.center
            collectionView.addSubview(movingCellSnapshot!)
            
            collectionView.visibleCells.forEach { cell in
                UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .repeat], animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: nil)
            }
            
            cell.isHidden = true
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
            movingCellSnapshot?.center = gesture.location(in: collectionView)
        case .ended, .cancelled:
            collectionView.endInteractiveMovement()
            if let snapshot = movingCellSnapshot {
                snapshot.removeFromSuperview()
            }
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let cell = collectionView.cellForItem(at: selectedIndexPath)
                cell?.isHidden = false
                stopCellShakeAnimation()
            }
        default:
            collectionView.cancelInteractiveMovement()
            if let snapshot = movingCellSnapshot {
                snapshot.removeFromSuperview()
            }
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let cell = collectionView.cellForItem(at: selectedIndexPath)
                cell?.isHidden = false
                stopCellShakeAnimation()
            }
        }
    }

    private func stopCellShakeAnimation() {
        collectionView.visibleCells.forEach { cell in
            cell.layer.removeAllAnimations()
            cell.transform = .identity
        }
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .gray
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.section][indexPath.item]
        print("Selected item: \(item)")
        print(items)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {

        return true
    }

    
    //뭔가 잘했지만 망한 코드 20 번째
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let sourceSection = sourceIndexPath.section
//        let sourceItem = sourceIndexPath.item
//        let destinationSection = destinationIndexPath.section
//        let destinationItem = destinationIndexPath.item
//
//        let item = items[sourceSection].remove(at: sourceItem)
//
//        items[destinationSection].insert(item, at: destinationItem)
//
//        collectionView.reloadData()
//    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let item = items[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        
        items[destinationIndexPath.section].insert(item, at: destinationIndexPath.item)
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        // 가운데 맞출려고 했었던 코드
        let adjustedIndexPath = IndexPath(item: (collectionView.numberOfItems(inSection: proposedIndexPath.section) / 2), section: proposedIndexPath.section)
        return adjustedIndexPath
    }
}
