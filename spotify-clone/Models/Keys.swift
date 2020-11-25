//
//  Keys.swift
//  spotify-clone
//
//  Created by Anika Morris on 11/17/20.
//

import Foundation

struct Constants {
    static let redirectUri = URL(string:"spotify-clone://")!
    static let clientId = "ef0646a94ef649f1a2b5cb7978f2dbc4"
    static let clientSecret = "fef7b4c839f74db3a54c0777cc270963"
    
    static let scopes: SPTScope = [.userReadEmail, .userReadPrivate,
    .userReadPlaybackState, .userModifyPlaybackState,
    .userReadCurrentlyPlaying, .streaming, .appRemoteControl,
    .playlistReadCollaborative, .playlistModifyPublic, .playlistReadPrivate, .playlistModifyPrivate,
    .userLibraryModify, .userLibraryRead,
    .userTopRead, .userReadPlaybackState, .userReadCurrentlyPlaying,
    .userFollowRead, .userFollowModify,]

    static let stringScopes = ["user-read-email", "user-read-private",
    "user-read-playback-state", "user-modify-playback-state", "user-read-currently-playing",
    "streaming", "app-remote-control",
    "playlist-read-collaborative", "playlist-modify-public", "playlist-read-private", "playlist-modify-private",
    "user-library-modify", "user-library-read",
    "user-top-read", "user-read-playback-position", "user-read-recently-played",
    "user-follow-read", "user-follow-modify",]
}
