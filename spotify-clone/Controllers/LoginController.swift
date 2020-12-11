//
//  LoginController.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/10/20.
//

import Foundation
import AuthenticationServices

class LoginController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    //MARK: Properties
    var coordinator: AppCoordinator!
    
    //MARK: Views
    let logoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .skyBlue
        return view
    }()
    
    let aFlatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "A♭"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 60.0)
        return label
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Like Spotify, just less cool."
        label.font = UIFont(name: "Futura", size: 20.0)
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.setTitle("Login", for: .normal)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 8.0
        button.layer.shadowRadius = 5.0
        button.layer.shadowColor = CGColor(gray: 0.0, alpha: 1.0)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.backgroundColor = .ultraRed
        return button
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: Methods
    func setupViews() {
        view.backgroundColor = .background
        view.addSubview(logoView)
        let viewWidth = view.bounds.width
        let logoViewCornerRadius = viewWidth * 0.8 / 2
        logoView.layer.cornerRadius = logoViewCornerRadius
        NSLayoutConstraint.activate([
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0)
        ])
        logoView.addSubview(aFlatLabel)
        NSLayoutConstraint.activate([
            aFlatLabel.widthAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 0.8),
            aFlatLabel.heightAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.2),
            aFlatLabel.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            aFlatLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor, constant: -20.0)
        ])
        logoView.addSubview(tagLabel)
        NSLayoutConstraint.activate([
            tagLabel.widthAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 0.8),
            tagLabel.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            tagLabel.heightAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.4),
            tagLabel.topAnchor.constraint(equalTo: aFlatLabel.bottomAnchor, constant: -40.0)
        ])
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 60.0),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60.0)
        ])
    }
    
    //MARK: Protocol Method
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    //MARK: Button Methods
    @objc func loginButtonTapped() {
        let scopeAsString = Constants.stringScopes.joined(separator: "%20")
        let url = URL(string: "https://accounts.spotify.com/authorize?client_id=\(Constants.clientId)&response_type=code&redirect_uri=\(Constants.redirectUri)&scope=\(scopeAsString)")!
        let scheme = "auth"
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else { return }
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard let requestToken = queryItems?.first(where: { $0.name == "code" })?.value else { return }
            print("Code \(requestToken)")
            NetworkManager.authorizationCode = requestToken
            NetworkManager.fetchAccessToken { (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        self?.presentAlert(title: "Error Logging In", message: "\(error.localizedDescription)")
                    }
                case .success(let spotifyAuth):
                    print("access token \(spotifyAuth.accessToken)")
                    NetworkManager.fetchUser(accessToken: spotifyAuth.accessToken) { [weak self] (result) in
                        switch result{
                        case .failure(let error):
                            self?.presentAlert(title: "Error Logging In", message: "\(error.localizedDescription)")
                        case .success(let user):
                            print(user)
                            self?.coordinator.goToHomeController()
                        }
                    }
                }
            }
        }
    session.presentationContextProvider = self
    session.start()
    }
}
