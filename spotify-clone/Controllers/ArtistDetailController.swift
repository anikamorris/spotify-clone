//
//  ArtistDetailController.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/10/20.
//

import Foundation
import UIKit
import Spartan

class ArtistDetailController: UIViewController {
    
    //MARK: Properties
    var coordinator: TabBarCoordinator!
    var artist: Artist! = nil
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
        self.title = artist.name
        fetchTopTracks()
        setupViews()
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
    
    func fetchTopTracks() {
        guard let artistId = artist.id as? String else { return }
        NetworkManager.fetchArtistTopTracks(artistId: artistId) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.presentAlert(title: "Error", message: "Unable to fetch tracks: \(error)")
            case .success(let tracks):
                print(tracks)
                self.tracks = tracks
                DispatchQueue.main.async {
                    self.trackTableView.reloadData()
                }
            }
        }
    }
}

extension ArtistDetailController: UITableViewDelegate {
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

extension ArtistDetailController: UITableViewDataSource {
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
