//
//  TabBarController.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/10/20.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    //MARK: Properties
    var coordinator: TabBarCoordinator!
    
    //MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.skyBlue
    }
}

