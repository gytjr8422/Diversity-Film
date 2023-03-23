//
//  TabBarController.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = UIColor(rgb: 0xFCF6F5)
        self.tabBar.tintColor = UIColor(rgb: 0x7b9acc)
    }
    
}
