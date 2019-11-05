//
//  StartScreen.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 16/12/2018.
//  Copyright © 2018 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import WebKit

class StartScreenViewController: UIViewController {
    @IBOutlet weak var dotOne: UIImageView!
    @IBOutlet weak var dotTwo: UIImageView!
    @IBOutlet weak var dotThree: UIImageView!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBAction func loginButtonPushed(_ sender: UIButton) {
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
    }
    
    func deleteCookies() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records) {
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        self.heading.center.y += self.view.bounds.height
                        self.logInButton.center.x += self.view.bounds.width
        },
                       completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationDotOne()
    }
    
    let duration: TimeInterval = 0.3
    let delay = 0.2
    let alphaStart: CGFloat = 0.2
    let alphaEnd: CGFloat = 1
    
    func animationDotOne() {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       animations: {
                        self.dotOne.alpha = self.alphaStart
                        self.dotOne.alpha = self.alphaEnd},
                       completion: { _ in self.animationDotTwo() }
        )
    }
    
    func animationDotTwo() {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       animations: {self.dotTwo.alpha = self.alphaStart
                        self.dotTwo.alpha = self.alphaEnd},
                       completion: { _ in self.animationDotThree() }
        )
    }
    
    func animationDotThree() {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       animations: {self.dotThree.alpha = self.alphaStart
                        self.dotThree.alpha = self.alphaEnd},
                       completion: { _ in self.animationDotOne() }
        )
    }
}
