//
//  FavoritesController.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/10/20.
//

import Foundation
import UIKit

class FavoritesController: UIViewController {
    
    //MARK: Properties
    var coordinator: TabBarCoordinator!
    
    //MARK: Views
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: Methods
    func setupViews() {
        view.backgroundColor = .background
    }
}
