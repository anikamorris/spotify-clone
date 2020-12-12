//
//  TrackDetailController.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/11/20.
//

import Foundation
import UIKit
import Spartan
import AVFoundation

class TrackDetailController: UIViewController {
    
    //MARK: Properties
    var coordinator: TabBarCoordinator!
    var track: Track!
    var trackImage: UIImage?
    var player: AVPlayer?
    var playButtonState = PlayButtonState.unselected
    var favoriteButtonState = FavoriteButtonState.unselected
    
    //MARK: Views
    let trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .ultraRed
        return imageView
    }()
    let songLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()
    let albumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    let buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = .royalIndigo
        return button
    }()
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        button.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .royalIndigo
        return button
    }()
    let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSongPreview()
        setFavoriteButtonState()
        setupViews()
    }
    
    //MARK: Methods
    private func setupViews() {
        setImage()
        setLabelText()
        view.backgroundColor = .background
        view.addSubview(trackImageView)
        NSLayoutConstraint.activate([
            trackImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            trackImageView.heightAnchor.constraint(equalTo: trackImageView.widthAnchor),
            trackImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50.0)
        ])
        view.addSubview(songLabel)
        NSLayoutConstraint.activate([
            songLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            songLabel.heightAnchor.constraint(equalToConstant: 40.0),
            songLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            songLabel.topAnchor.constraint(equalTo: trackImageView.bottomAnchor, constant: 30.0)
        ])
        view.addSubview(albumLabel)
        NSLayoutConstraint.activate([
            albumLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            albumLabel.heightAnchor.constraint(equalToConstant: 30.0),
            albumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumLabel.topAnchor.constraint(equalTo: songLabel.bottomAnchor)
        ])
        view.addSubview(slider)
        NSLayoutConstraint.activate([
            slider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0),
            slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30.0),
            slider.heightAnchor.constraint(equalToConstant: 30.0)
        ])
        view.addSubview(buttonStack)
        buttonStack.addArrangedSubview(playButton)
        buttonStack.addArrangedSubview(favoriteButton)
        NSLayoutConstraint.activate([
            buttonStack.widthAnchor.constraint(equalToConstant: 60.0),
            buttonStack.heightAnchor.constraint(equalToConstant: 30.0),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30.0)
        ])
    }
    
    func setLabelText() {
        let trackName = track.name
        let albumName = track.album.name
        songLabel.text = trackName
        albumLabel.text = albumName
    }
    
    func setImage() {
        if let image = trackImage {
            trackImageView.image = image
        } else {
            let imageUrl = track.album.images.first?.url
            downloadImage(from: imageUrl)
        }
    }
    
    func fetchSongPreview() {
        let urlString = track.previewUrl
        guard let url = URL(string: urlString!) else { return }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
    }
    
    func downloadImage(from urlString: String?) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let _ = error { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.trackImageView.image = image
            }
        }
        task.resume()
    }
    
    func setFavoriteButtonState() {
        let trackId = track.id as! String
        if let favorites = UserDefaults.standard.value(forKey: "favorites") as? [String] {
            for i in 0...favorites.count-1 {
                if favorites[i] == trackId {
                    favoriteButtonState = .selected
                }
            }
        }
        favoriteButtonState = .unselected
    }
    
    //MARK: Helpers
    @objc func playButtonTapped() {
        playButtonState.toggle(for: playButton)
        if playButtonState == .selected {
            DispatchQueue.main.async { [weak self] in
                self?.player?.play()
            }
        } else {
            player?.pause()
        }
    }
    
    @objc func favoriteButtonTapped() {
        favoriteButtonState.toggle(for: favoriteButton)
        let trackId = track.id as! String
        if let favorites = UserDefaults.standard.value(forKey: "favorites") as? [String] {
            var newFavorites = favorites
            if favoriteButtonState == .selected {
                newFavorites.append(trackId)
            } else {
                for i in 0...newFavorites.count-1 {
                    if newFavorites[i] == trackId {
                        newFavorites.remove(at: i)
                    }
                }
            }
            UserDefaults.standard.setValue(newFavorites, forKey: "favorites")
        } else {
            let favorites: [String] = [trackId]
            UserDefaults.standard.setValue(favorites, forKey: "favorites")
        }
    }
}
