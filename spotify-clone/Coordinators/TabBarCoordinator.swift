//
//  TabBarCoordinator.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/10/20.
//

import Foundation
import UIKit
import Spartan

class TabBarCoordinator: NSObject, Coordinator, UITabBarControllerDelegate {
    
    //MARK: Properties
    var navigationController: UINavigationController
    var tabBarController = TabBarController()
    var childCoordinators: [Coordinator] = []
    var homeNavigationController: UINavigationController!
    var favoritesNavigationController: UINavigationController!
    
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
                                                           image: UIImage(systemName: "heart"),
                                                           selectedImage: UIImage(systemName: "heart.fill")
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
    func setUserName(name: String) {
        let homeController = homeNavigationController.viewControllers[0] as! HomeController
        homeController.userName = name
    }
    
    func setTabBarItemTitle() {
        homeNavigationController.tabBarItem.title = "Home"
    }
    
    func goToArtistDetail(artist: Artist) {
        let vc = ArtistDetailController()
        vc.coordinator = self
        vc.artist = artist
        homeNavigationController.pushViewController(vc, animated: true)
    }
    
    func goToTrackDetail(track: Track, trackImage: UIImage?) {
        let vc = TrackDetailController()
        vc.coordinator = self
        vc.track = track
        vc.trackImage = trackImage
        homeNavigationController.pushViewController(vc, animated: true)
    }
}
