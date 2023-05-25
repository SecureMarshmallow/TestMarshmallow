import UIKit
import SnapKit
import Then

class TestCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView1: UICollectionView
    var collectionView2: UICollectionView
    
    let cellIdentifier = "cell"
    var movingCellSnapshot: UIView?
    var sourceIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        collectionView1 = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView2 = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView1.dataSource = self
        collectionView1.delegate = self
        
        collectionView2.dataSource = self
        collectionView2.delegate = self
        
        collectionView1.backgroundColor = .red
        collectionView2.backgroundColor = .yellow
        
        collectionView1.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView2.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        view.addSubview(collectionView1)
        view.addSubview(collectionView2)
        
        collectionView1.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        collectionView2.snp.makeConstraints {
            $0.top.equalTo(collectionView1.snp.bottom).offset(20.0)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        let longPressGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        collectionView1.addGestureRecognizer(longPressGesture1)
        
        let longPressGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        collectionView2.addGestureRecognizer(longPressGesture2)
    }
        let longPressGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        collectionView1.addGestureRecognizer(longPressGesture1)
        
        let longPressGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        collectionView2.addGestureRecognizer(longPressGesture2)
    }
    
    @objc func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionView = gesture.view as? UICollectionView else {
            return
        }
        
        switch gesture.state {
        case .began:
            let location = gesture.location(in: collectionView)
            
            guard let selectedIndexPath = collectionView.indexPathForItem(at: location),
                  collectionView.cellForItem(at: selectedIndexPath) != nil else {
                return
            }
            
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            
            let cell = collectionView.cellForItem(at: selectedIndexPath)!
            movingCellSnapshot = cell.snapshotView(afterScreenUpdates: false)
            movingCellSnapshot?.center = cell.center
            collectionView.addSubview(movingCellSnapshot!)
            cell.isHidden = true
            sourceIndexPath = selectedIndexPath
            
        case .changed:
            let location = gesture.location(in: collectionView)
            
            guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else {
                return
            }
            
            collectionView.updateInteractiveMovementTargetPosition(location)
            movingCellSnapshot?.center = location
            
        case .ended:
            let location = gesture.location(in: collectionView)
            
            guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else {
                return
            }
            
            collectionView.endInteractiveMovement()
            if let snapshot = movingCellSnapshot {
                snapshot.removeFromSuperview()
            }
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                collectionView.cellForItem(at: selectedIndexPath)?.isHidden = false
            }
            sourceIndexPath = nil
            
        default:
            let location = gesture.location(in: collectionView)
            
            guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else {
                return
            }
            
            collectionView.cancelInteractiveMovement()
            if let snapshot = movingCellSnapshot {
                snapshot.removeFromSuperview()
            }
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                collectionView.cellForItem(at: selectedIndexPath)?.isHidden = false
            }
            sourceIndexPath = nil
        }
    }
    

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if collectionView == collectionView1 {
            collectionView2.performBatchUpdates({
                collectionView1.deleteItems(at: [sourceIndexPath])
                collectionView2.insertItems(at: [destinationIndexPath])
            }, completion: nil)
        } else if collectionView == collectionView2 {
            collectionView1.performBatchUpdates({
                collectionView2.deleteItems(at: [sourceIndexPath])
                collectionView1.insertItems(at: [destinationIndexPath])
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if collectionView == collectionView1 {
            return IndexPath(item: (proposedIndexPath.item / 2), section: proposedIndexPath.section)
        } else if collectionView == collectionView2 {
            return IndexPath(item: (proposedIndexPath.item * 2), section: proposedIndexPath.section)
        }
        return proposedIndexPath
    }
}
