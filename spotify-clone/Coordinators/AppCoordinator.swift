//
//  AppCoordinator.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/10/20.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators: [Coordinator] = []
    lazy var navigationController: UINavigationController = UINavigationController()
    
    //MARK: Init
    init(window: UIWindow) {
        window.rootViewController = navigationController
        configureNavBar()
    }
    
    //MARK: Methods
    func start() {
        let vc = LoginController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToHomeController(userName: String) {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.start()
        tabBarCoordinator.setUserName(name: userName)
    }
    
    private func configureNavBar() {
        self.navigationController.navigationBar.isHidden = true
    }
}
