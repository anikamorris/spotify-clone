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
    static private let defaults = UserDefaults.standard
    
    // url components
    static let urlSession = URLSession.shared
    static private let baseURL = "https://accounts.spotify.com/"
    static private var parameters: [String: String] = [:]
    
    static let clientId = Constants.clientId
    static let clientSecretKey = Constants.clientSecret
    static let redirectURI: String = Constants.redirectUri
    
    static let accessTokenKey: String = "accessTokenKey"
    static let authorizationCodeKey: String = "authorizationCodeKey"
    static let refreshTokenKey: String = "refreshTokenKey"
    
    static var totalCount: Int = Int.max
    static var codeVerifier: String = ""

    static let stringScopes: [String] = [
        "user-read-email", "user-read-private",
        "user-read-playback-state", "user-modify-playback-state",
        "user-read-currently-playing", "streaming",
        "app-remote-control", "playlist-read-collaborative",
        "playlist-modify-public", "playlist-read-private",
        "playlist-modify-private", "user-library-modify",
        "user-library-read", "user-top-read",
        "user-read-playback-position", "user-read-recently-played",
        "user-follow-read", "user-follow-modify"
    ]
    
    static var accessToken = defaults.string(forKey: accessTokenKey) {
        didSet { defaults.set(accessToken, forKey: accessTokenKey) }
    }
    static var authorizationCode = defaults.string(forKey: authorizationCodeKey) {
        didSet { defaults.set(authorizationCode, forKey: authorizationCodeKey) }
    }
    static var refreshToken = defaults.string(forKey: refreshTokenKey) {
        didSet { defaults.set(refreshToken, forKey: refreshTokenKey) }
    }
    
    //MARK: POST Request
    //fetch Spotify access token.
    static func fetchAccessToken(completion: @escaping (Result<SpotifyAuth, Error>) -> Void) {
        guard let code = authorizationCode else { return completion(.failure(ErrorMessage.missing(message: "No authorization code found."))) }
        let url = URL(string: "\(baseURL)api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((clientId + ":" + clientSecretKey).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                       "Content-Type": "application/x-www-form-urlencoded"]
        var requestBodyComponents = URLComponents()
        let scopeAsString = stringScopes.joined(separator: " ") //scope array to string separated by whitespace
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code_verifier", value: codeVerifier),
            URLQueryItem(name: "scope", value: scopeAsString),
        ]
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                return completion(.failure(ErrorMessage.noData(message: "No data found")))
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                if let spotifyAuth = try? decoder.decode(SpotifyAuth.self, from: data) {
                    self.accessToken = spotifyAuth.accessToken
                    self.authorizationCode = nil
                    self.refreshToken = spotifyAuth.refreshToken
                    return completion(.success(spotifyAuth))
                }
                completion(.failure(ErrorMessage.couldNotParse(message: "Couldn't decode data")))
            }
        }
        task.resume()
    }
}

