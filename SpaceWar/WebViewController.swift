//
//  WebViewController.swift
//  SpaceWar
//
//  Created by Mikhailov on 15.11.2020.
//

import WebKit

class WebViewController: UIViewController {
    
    //MARK: - Public properties
    weak var delegate: IWebCompletionDelegate?
    
    //MARK: - Private properties
    
    private let webView = WKWebView(frame: UIScreen.main.bounds)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://google.com")
        setToolBar()
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
    
    fileprivate func setToolBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 15))
        toolBar.items = [backButton]
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(toolBar)
        
        // Constraints
        toolBar.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: 0).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 0).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: 0).isActive = true
    }
    
    @objc private func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

@objc protocol IWebCompletionDelegate {
    @objc optional func webViewDidDisappear()
}
