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
    
    //MARK: Views
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .royalIndigo
        return button
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Methods
    func setupViews() {
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
}
