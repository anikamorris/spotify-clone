//
//  HomeController.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/10/20.
//

import Foundation
import UIKit

class HomeController: UIViewController {
    
    //MARK: Properties
    var coordinator: TabBarCoordinator!
    
    //MARK: Views
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Methods
    func setupViews() {
        view.backgroundColor = .background
    }
}
