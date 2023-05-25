import UIKit
import SnapKit
import Then

class CustomCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView1: UICollectionView?
    var collectionView2: UICollectionView?
    
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
        
        collectionView1 = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .red
            $0.dataSource = self
            $0.delegate = self
            $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        }
        
        collectionView2 = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .yellow
            $0.dataSource = self
            $0.delegate = self
            $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        }
        
        if let collectionView1 = collectionView1, let collectionView2 = collectionView2 {
            view.addSubview(collectionView1)
            view.addSubview(collectionView2)
            
            collectionView1.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.height.equalTo(200)
            }
            
            collectionView2.snp.makeConstraints {
                $0.top.equalTo(collectionView1.snp.bottom).offset(20)
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.height.equalTo(200)
            }
            
            let longPressGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
            collectionView1.addGestureRecognizer(longPressGesture1)
            
            let longPressGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
            collectionView2.addGestureRecognizer(longPressGesture2)
        }
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
            
            guard collectionView.indexPathForItem(at: location) != nil else {
                return
            }
            
            collectionView.updateInteractiveMovementTargetPosition(location)
            movingCellSnapshot?.center = location
            
        case .ended:
            let location = gesture.location(in: collectionView)
            
            guard collectionView.indexPathForItem(at: location) != nil else {
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
            
            guard collectionView.indexPathForItem(at: location) != nil else {
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
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .white
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if collectionView == collectionView1 {
            collectionView2?.performBatchUpdates({
                collectionView1?.deleteItems(at: [sourceIndexPath])
                collectionView2?.insertItems(at: [destinationIndexPath])
            }, completion: nil)
        } else if collectionView == collectionView2 {
            collectionView1?.performBatchUpdates({
                collectionView2?.deleteItems(at: [sourceIndexPath])
                collectionView1?.insertItems(at: [destinationIndexPath])
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
