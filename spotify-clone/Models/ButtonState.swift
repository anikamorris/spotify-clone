//
//  ButtonState.swift
//  spotify-clone
//
//  Created by Anika Morris on 12/11/20.
//

import Foundation
import UIKit

enum PlayButtonState {
    case selected
    case unselected

    mutating func toggle(for button: UIButton) {
        switch (self) {
        case .selected:
            self = .unselected
        case .unselected:
            self = .selected
        }
        button.setBackgroundImage(self.getBackgroundImage(), for: .normal)
    }

    private func getBackgroundImage() -> UIImage {
        switch (self) {
        case .selected:
            return UIImage(systemName: "pause")!
        case .unselected:
            return UIImage(systemName: "play")!
        }
    }
}

enum FavoriteButtonState {
    case selected
    case unselected

    mutating func toggle(for button: UIButton) {
        switch (self) {
        case .selected:
            self = .unselected
        case .unselected:
            self = .selected
        }
        button.setBackgroundImage(self.getBackgroundImage(), for: .normal)
    }

    private func getBackgroundImage() -> UIImage {
        switch (self) {
        case .selected:
            return UIImage(systemName: "heart.fill")!
        case .unselected:
            return UIImage(systemName: "heart")!
        }
    }
}
