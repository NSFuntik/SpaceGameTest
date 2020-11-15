//
//  WebViewController.swift
//  SpaceWar
//
//  Created by Mikhailov on 15.11.2020.
//

import WebKit

class WebViewController: UIViewController {

    //MARK - Public properties

    weak var delegate: WebCompletionDelegate?

    //MARK: - Private properties

    private let webView = WKWebView(frame: UIScreen.main.bounds)

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://google.com")
        setupWebView(with: url)
    }

    override func viewDidDisappear(_ animated: Bool) {
        delegate?.webViewDidDisappear?()
    }

    //MARK: - Private methods

    private func setupWebView(with url: URL?) {
        view.addSubview(webView)
        guard let url = url  else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }

}

@objc protocol WebCompletionDelegate {

   @objc optional func webViewDidDisappear()

}
