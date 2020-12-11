//
//  HomeController.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/01/20.
//

import Foundation
import UIKit
import Spartan

class HomeController: UIViewController {
    
    //MARK: Properties
    var coordinator: TabBarCoordinator!
    var artists: [Artist] = []
    
    //MARK: Views
    let artistTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
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
        artistTableView.dataSource = self
        artistTableView.delegate = self
        view.backgroundColor = .background
    }
    
    func fetchTopArtists(){
        NetworkManager.fetchTopArtists() { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.presentAlert(title: "Error", message: "Failed to get artists: \(error)")
            case .success(let artists):
                self?.artists = artists
                DispatchQueue.main.async {
                    self?.artistTableView.reloadData()
                }
            }
        }
    }
}

extension HomeController: UITableViewDelegate {}

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
