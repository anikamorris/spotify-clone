//
//  TrackCell.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/11/20.
//

import Foundation
import UIKit

class TrackCell: UITableViewCell {

    //MARK: Properties
    static let reuseIdentifier = "TrackCell"
    
    //MARK: Views
    let nameLabel: UILabel = {
        let label =  UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = .ultraRed
        return imageView
    }()
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    func setupViews() {
        contentView.addSubview(trackImageView)
        NSLayoutConstraint.activate([
            trackImageView.heightAnchor.constraint(equalToConstant: 60.0),
            trackImageView.widthAnchor.constraint(equalToConstant: 60.0),
            trackImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trackImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0)
        ])
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: trackImageView.trailingAnchor, constant: 30.0)
        ])
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
}

