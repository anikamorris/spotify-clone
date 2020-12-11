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
    var userName: String = ""
    
    //MARK: Views
    let artistTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArtistCell.self, forCellReuseIdentifier: ArtistCell.reuseIdentifier)
        return tableView
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTopArtists()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "\(userName)'s Top 50"
        coordinator.setTabBarItemTitle()
    }
    
    //MARK: Methods
    func setupViews() {
        view.backgroundColor = .background
        artistTableView.dataSource = self
        artistTableView.delegate = self
        view.addSubview(artistTableView)
        NSLayoutConstraint.activate([
            artistTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            artistTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            artistTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            artistTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
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

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        coordinator.goToArtistDetail(artist: artist)
    }
}

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArtistCell.reuseIdentifier) as! ArtistCell
        let artist = artists[indexPath.row]
        let artistImageUrL = artist.images.first?.url
        cell.nameLabel.text = artist.name
        cell.downloadImage(from: artistImageUrL)
        return cell
    }
}
