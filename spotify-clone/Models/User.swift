//
//  User.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/10/20.
//

import Foundation
import Spartan

struct User {
    private(set) var name: String
    private(set) var email: String?
    private(set) var userId: String
    private(set) var imageUrl: String?
    
    init(user: PrivateUser) {
        self.name = user.displayName!
        self.email = user.email
        self.userId = user.id as! String
        self.imageUrl = user.images?.first?.url
    }
}
