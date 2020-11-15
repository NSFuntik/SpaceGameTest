//
//  LinksService.swift
//  SpaceWar
//
//  Created by Mikhailov on 15.11.2020.
//

import Foundation

final class LinksService {

    //MARK: - typealias

    typealias EmptyCloser = (() -> Void)

    //MARK: - Public properties

    static let shared = LinksService()
    
    var deepLink: URL? {
        willSet {
            print(newValue ?? "could't load link")
        }
    }

    //MARK: - Private properties

    private var completion: EmptyCloser?

    //MARK: - Public methods

    func handleDeepLinkURL(_ url: URL?, completion: EmptyCloser?) {
        guard let url = url else {
            return
        }
        deepLink = url
        completion?()
        self.completion?()
    }

    func setCompletion(_ completion: EmptyCloser?) {
        self.completion = completion
    }

}
