//
//  SpotifyAuth.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/10/20.
//

import Foundation

struct SpotifyAuth: Codable {
    public let tokenType: String //Bearer
    public let refreshToken: String?
    public let accessToken: String
    public let expiresIn: Int
    public let scope: String
}
