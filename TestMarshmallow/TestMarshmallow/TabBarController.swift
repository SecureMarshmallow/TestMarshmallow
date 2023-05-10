//
//  TabBarController.swift
//  TestMarshmallow
//
//  Created by 박준하 on 2023/05/10.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let timeLimitVC = TimeLimitViewController()
        timeLimitVC.title = "Time Limit"
        let navController = UINavigationController(rootViewController: timeLimitVC)
        navController.tabBarItem.image = UIImage(systemName: "clock")
        
        viewControllers = [navController]
    }
}
