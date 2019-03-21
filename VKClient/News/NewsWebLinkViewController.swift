//
//  NewsWebLinkViewController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 21/03/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import WebKit

class NewsWebLinkViewController: UIViewController {
    
    var webURL = ""
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: URL(string: "https://www.yandex.ru")!))
    }
}
