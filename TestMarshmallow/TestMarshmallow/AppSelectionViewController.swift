import UIKit

struct App {
    let name: String
    let icon: UIImage
}

class AppSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // AppSelectionViewController는 App 리스트를 표시합니다.
    // App 리스트는 App 구조체의 배열입니다.
    var apps: [App] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // 선택된 App을 저장하는 변수
    var selectedApp: App?
    
    // UITableView를 생성합니다.
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        // UITableView의 Layout 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // UITableViewDataSource의 함수
    // UITableView에 표시할 Cell의 개수를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }
    
    // UITableViewDataSource의 함수
    // UITableView에 표시할 Cell을 생성합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let app = apps[indexPath.row]
        cell.textLabel?.text = app.name
        return cell
    }
    
    // UITableViewDelegate의 함수
    // UITableView에서 Cell을 선택했을 때 동작을 처리합니다.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedApp = apps[indexPath.row]
        dismiss(animated: true, completion: nil)
    }
}
