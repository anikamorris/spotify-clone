//
//  TabBarCoordinator.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/10/20.
//

import Foundation
import UIKit

class TabBarCoordinator: NSObject, Coordinator, UITabBarControllerDelegate {
    
    //MARK: Properties
    var navigationController: UINavigationController
    var tabBarController = TabBarController()
    var childCoordinators: [Coordinator] = []
    var homeNavigationController: UINavigationController!
    var favoritesNavigationController: UINavigationController!
//    var historyNavigationController: UINavigationController!
//    var profileNavigationController: UINavigationController!
    
    //MARK: Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: Methods
    func start() {
        tabBarController.coordinator = self
        tabBarController.delegate = self

        let homeController = HomeController()
        homeController.coordinator = self
        homeNavigationController = UINavigationController(rootViewController: homeController)
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home",
                                                           image: UIImage(systemName: "house"),
                                                           selectedImage: UIImage(systemName: "house.fill")
                                                        )
        
        let favoritesController = FavoritesController()
        favoritesController.coordinator = self
        favoritesNavigationController = UINavigationController(rootViewController: favoritesController)
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "Favorites",
                                                           image: UIImage(systemName: "star"),
                                                           selectedImage: UIImage(systemName: "star.fill")
                                                        )
        
        tabBarController.viewControllers = [
                                                homeNavigationController,
                                                favoritesNavigationController
                                            ]
        
        tabBarController.modalPresentationStyle = .fullScreen
        navigationController.present(tabBarController, animated: false, completion: nil)
    }
}

//MARK: Home Flow
extension TabBarCoordinator {
    
}
