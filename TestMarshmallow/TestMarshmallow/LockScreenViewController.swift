import UIKit

class LockScreenViewController: UIViewController {
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 입력"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.isEnabled = false
        return textField
    }()
    
    private let numberCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NumberButtonCell.self, forCellWithReuseIdentifier: "NumberButtonCell")
        return collectionView
    }()
    
    private let passwordLimit = 6
    private var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(passwordTextField)
        view.addSubview(numberCollectionView)
        
        passwordTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
        
        numberCollectionView.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).offset(-20)
            $0.height.equalTo(240)
        }
        
        numberCollectionView.dataSource = self
        numberCollectionView.delegate = self
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGestureRecognizer.minimumPressDuration = 0
        numberCollectionView.addGestureRecognizer(longPressGestureRecognizer)
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("지우기", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(numberCollectionView.snp.bottom).offset(20)
        }
    }
    
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: numberCollectionView)
        
        guard let indexPath = numberCollectionView.indexPathForItem(at: point) else {
            return
        }
        
        if gestureRecognizer.state == .began {
            guard let cell = numberCollectionView.cellForItem(at: indexPath) as? NumberButtonCell else {
                return
            }
            
            cell.highlight(true)
        } else if gestureRecognizer.state == .ended {
            guard let cell = numberCollectionView.cellForItem(at: indexPath) as? NumberButtonCell else {
                return
            }
            
            cell.highlight(false)
            addNumberToPassword(cell.number)
        }
    }
    
    @objc private func deleteButtonTapped() {
        if !password.isEmpty {
            password.removeLast()
            passwordTextField.text = password
        }
    }
    
    private func addNumberToPassword(_ number: String) {
        guard password.count < passwordLimit else {
            return
        }
        
        password += number
        passwordTextField.text = password
        
        if password.count == passwordLimit {
            // 비밀번호 입력 완료
            // 이후 처리 로직 추가
        }
    }
}

extension LockScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberButtonCell", for: indexPath) as! NumberButtonCell
        cell.number = "\(indexPath.item + 1)"
        return cell
    }
}

extension LockScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NumberButtonCell else {
            return
        }
        
        addNumberToPassword(cell.number)
    }
}

extension LockScreenViewController: UICollectionViewDelegateFlowLayout {
    
}


class NumberButtonCell: UICollectionViewCell {
    var number: String = "" {
        didSet {
            numberLabel.text = number
        }
    }
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .gray : .systemBlue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        contentView.backgroundColor = .red
        addSubview(numberLabel)
        
        numberLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    
    func highlight(_ isHighlighted: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.transform = isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
        }
    }
}
