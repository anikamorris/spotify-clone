//
//  NetworkManager.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/10/20.
//

import Foundation
import Spartan

enum ErrorMessage: Error {
    case couldNotParse(message: String)
    case noData(message: String)
    case unsupportedEndpoint(message: String)
    case endpointError(message: String)
    case maximumResultsReached(message: String = "You have reached maximum amount articles. Upgrade your account to see more.")
    case unknown(message: String = "Error status with no error message")
    case missing(message: String)
}

extension ErrorMessage: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case let .couldNotParse(message),
                 let .noData(message),
                 let .unsupportedEndpoint(message),
                 let .endpointError(message),
                 let .maximumResultsReached(message),
                 let .unknown(message),
                 let .missing(message):
                return message
        }
    }
}

class NetworkManager {
    
    //MARK: Singleton
    public static let shared = NetworkManager()
    private init() {}
    
    //MARK: Properties
    static let urlSession = URLSession.shared
    static private let baseURL = "https://accounts.spotify.com/"
    static private var parameters: [String: String] = [:]
    
    static let clientId = Constants.clientId
    static let clientSecretKey = Constants.clientSecret
    static let redirectURI: String = Constants.redirectUri
    
    static let accessTokenKey: String = "accessTokenKey"
    static let authorizationCodeKey: String = "authorizationCodeKey"
    static let refreshTokenKey: String = "refreshTokenKey"
    
    static private let defaults = UserDefaults.standard
    
    static var totalCount: Int = Int.max
    static var codeVerifier: String = ""

    static let stringScopes: [String] = []
    
    static var accessToken = defaults.string(forKey: accessTokenKey) {
        didSet { defaults.set(accessToken, forKey: accessTokenKey) }
    }
    static var authorizationCode = defaults.string(forKey: authorizationCodeKey) {
        didSet { defaults.set(authorizationCode, forKey: authorizationCodeKey) }
    }
    static var refreshToken = defaults.string(forKey: refreshTokenKey) {
        didSet { defaults.set(refreshToken, forKey: refreshTokenKey) }
    }
}

