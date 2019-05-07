//
//  MainViewController.swift
//  KatKat
//
//  Created by Zhaowei Wu on 5/7/19.
//  Copyright © 2019 Zhaowei Wu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import Alamofire
import Reachability
import SwiftMessages

class MainViewController: UIViewController {
    
    let reachability = Reachability()!
    var currentReachability: Bool? = nil
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var meowButton: UIButton!
    
    @IBAction func didTapMeowButton(_ sender: Any) {
        fetchAndDisplayImg()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setReachabilityNotifier()
        fetchAndDisplayImg()
    }
    
    private func setUI() {
        meowButton.layer.cornerRadius = 10
        meowButton.addShadow()
    }
    
    private func setReachabilityNotifier() {
        reachability.whenReachable = { reachability in
            // Do not notify reachability if connected via wifi initially
            if reachability.connection == .wifi && self.currentReachability != nil {
                self.reachabilityDidChange(connection: .wifi)
            } else if reachability.connection == .cellular {
                self.reachabilityDidChange(connection: .cellular)
            }
            self.currentReachability = true
        }
        reachability.whenUnreachable = { reachability in
            self.reachabilityDidChange(connection: .none)
            self.currentReachability = false
        }
        try? reachability.startNotifier()
    }
    
    private func fetchAndDisplayImg() {
        AF.request("https://api.thecatapi.com/v1/images/search").responseData { dataRes in
            if let data = dataRes.data, let json = try? JSON(data: data), let imgUrl = URL(string: json[0]["url"].stringValue) {
                self.imgView.kf.setImage(with: imgUrl)
            }
        }
    }
    
    private func reachabilityDidChange(connection: Reachability.Connection) {
        let messageView = MessageView.viewFromNib(layout: .statusLine)
        var message = "Welcome back online!"
        switch connection {
        case .cellular:
            message = "Using cellular data. Watch out!"
        case .wifi:
            message = "Welcome back online!"
        case .none:
            message = "You are offline. No more cats :<"
        }
        messageView.configureContent(body: message)
        messageView.layoutMarginAdditions = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        messageView.addShadow()
        SwiftMessages.show(view: messageView)
    }


}

extension UIView {
    func addShadow(radius: CGFloat = 10, color: CGColor = UIColor.black.cgColor, opacity: Float = 0.1, offset: CGSize = .zero) {
        layer.shadowRadius = radius
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
    }
}

