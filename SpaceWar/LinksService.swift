//
//  LinksService.swift
//  SpaceWar
//
//  Created by Mikhailov on 15.11.2020.
//

import Foundation

final class LinksService {

    // Typealias
    typealias EmptyClosure = (() -> Void)

    // Public properties
    static let shared = LinksService()
    
    var deepLink: URL? {
        willSet {
            print(newValue ?? "could't load link")
        }
    }

    // Private properties
    private var completion: EmptyClosure?

    // Public methods
    func handleDeepLinkURL(_ url: URL?, completion: EmptyClosure?) {
        guard let url = url else { return }
        deepLink = url
        completion?()
        self.completion?()
    }

    func setCompletion(_ completion: EmptyClosure?) {
        self.completion = completion
    }
}
