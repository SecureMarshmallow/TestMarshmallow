import UIKit

class ViewController2: UIViewController {
    var collectionView1: UICollectionView!
    var collectionView2: UICollectionView!
    
    var collectionView1Data = ["Cell 1", "Cell 2", "Cell 3"]
    var collectionView2Data = ["Cell A", "Cell B", "Cell C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionView1FlowLayout = UICollectionViewFlowLayout()
        collectionView1FlowLayout.itemSize = CGSize(width: 100, height: 50)
        collectionView1FlowLayout.scrollDirection = .vertical
        
        collectionView1 = UICollectionView(frame: CGRect(x: 20, y: 100, width: 300, height: 200), collectionViewLayout: collectionView1FlowLayout)
        collectionView1.backgroundColor = .white
        collectionView1.dataSource = self
        collectionView1.delegate = self
        collectionView1.dragDelegate = self
        collectionView1.dropDelegate = self
        collectionView1.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView1Cell")
        view.addSubview(collectionView1)
        
        let collectionView2FlowLayout = UICollectionViewFlowLayout()
        collectionView2FlowLayout.itemSize = CGSize(width: 100, height: 50)
        collectionView2FlowLayout.scrollDirection = .vertical
        
        collectionView2 = UICollectionView(frame: CGRect(x: 20, y: 350, width: 300, height: 200), collectionViewLayout: collectionView2FlowLayout)
        collectionView2.backgroundColor = .white
        collectionView2.dataSource = self
        collectionView2.delegate = self
        collectionView2.dragDelegate = self
        collectionView2.dropDelegate = self
        collectionView2.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionView2Cell")
        view.addSubview(collectionView2)
    }
    
}

extension ViewController2: UICollectionViewDropDelegate {
    
}

extension ViewController2: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return collectionView1Data.count
        } else if collectionView == collectionView2 {
            return collectionView2Data.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView1Cell", for: indexPath)
            cell.backgroundColor = .blue
            return cell
        } else if collectionView == collectionView2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView2Cell", for: indexPath)
            cell.backgroundColor = .red
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ViewController2: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionView1 {
            print("collectionView1")
        }
        
        if collectionView == collectionView2 {
            print("collectionView2")
        }
    }
}
    
extension ViewController2: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if collectionView == collectionView1 {
            let selectedData = collectionView1Data[indexPath.item]
            let itemProvider = NSItemProvider(object: selectedData as NSString)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = (collectionView, indexPath)
            return [dragItem]
        } else if collectionView == collectionView2 {
            let selectedData = collectionView2Data[indexPath.item]
            let itemProvider = NSItemProvider(object: selectedData as NSString)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = (collectionView, indexPath)
            return [dragItem]
        }
        return []
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let operation: UIDropOperation
        
        if session.localDragSession != nil {
            operation = .move
        } else {
            operation = .copy
        }
        
        return UICollectionViewDropProposal(operation: operation, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        if let (sourceCollectionView, sourceIndexPath) = coordinator.items.first?.dragItem.localObject as? (UICollectionView, IndexPath) {
            let draggedData: String
            
            if sourceCollectionView == collectionView1 {
                draggedData = collectionView1Data[sourceIndexPath.item]
                collectionView1Data.remove(at: sourceIndexPath.item)
            } else if sourceCollectionView == collectionView2 {
                draggedData = collectionView2Data[sourceIndexPath.item]
                collectionView2Data.remove(at: sourceIndexPath.item)
            } else {
                return
            }
            
            collectionView.performBatchUpdates({
                if collectionView == collectionView1 {
                    collectionView1Data.insert(draggedData, at: destinationIndexPath.item)
                } else if collectionView == collectionView2 {
                    collectionView2Data.insert(draggedData, at: destinationIndexPath.item)
                }
                
                collectionView.insertItems(at: [destinationIndexPath])
                
                if sourceCollectionView == collectionView1 {
                    collectionView1.deleteItems(at: [sourceIndexPath])
                } else if sourceCollectionView == collectionView2 {
                    collectionView2.deleteItems(at: [sourceIndexPath])
                }
            }, completion: nil)
            
            coordinator.drop(coordinator.items.first!.dragItem, toItemAt: destinationIndexPath)
        }
    }
}
