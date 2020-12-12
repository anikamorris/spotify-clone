//
//  FavoritesController.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/10/20.
//

import Foundation
import UIKit
import Spartan

class FavoritesController: UIViewController {
    
    //MARK: Properties
    var coordinator: TabBarCoordinator!
    var tracks: [Track] = []
    
    //MARK: Views
    let trackTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseIdentifier)
        return tableView
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFavoriteTracks()
        setupViews()
        self.title = "Favorites"
    }
    
    //MARK: Methods
    func setupViews() {
        view.backgroundColor = .background
        trackTableView.dataSource = self
        trackTableView.delegate = self
        view.addSubview(trackTableView)
        NSLayoutConstraint.activate([
            trackTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func fetchFavoriteTracks() {
        guard let trackIds = UserDefaults.standard.array(forKey: "favorites") as? [String] else {
            self.presentAlert(title: "No favorites yet.", message: "Go favorite some of your top tracks!")
            return
        }
        NetworkManager.fetchTracksById(ids: trackIds) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.presentAlert(title: "Error", message: "Failed to get tracks: \(error)")
            case .success(let tracks):
                self?.tracks = tracks
                DispatchQueue.main.async {
                    self?.trackTableView.reloadData()
                }
            }
        }
    }
}

extension FavoritesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! TrackCell
        guard let image = cell.trackImageView.image else {
            coordinator.goToTrackDetail(track: track, trackImage: nil)
            return
        }
        coordinator.goToTrackDetail(track: track, trackImage: image)
    }
}

extension FavoritesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifier) as! TrackCell
        let track = tracks[indexPath.row]
        let imageUrl = track.album.images.first?.url
        cell.nameLabel.text = track.name
        cell.downloadImage(from: imageUrl)
        return cell
    }
}
