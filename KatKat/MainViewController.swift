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

class MainViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var meowButton: UIButton!
    
    @IBAction func didTapMeowButton(_ sender: Any) {
        fetchAndDisplayImg()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        fetchAndDisplayImg()
    }
    
    private func setUI() {
        meowButton.layer.cornerRadius = 10
        meowButton.addShadow()
    }
    
    private func fetchAndDisplayImg() {
        AF.request("https://api.thecatapi.com/v1/images/search").responseData { dataRes in
            if let data = dataRes.data, let json = try? JSON(data: data), let imgUrl = URL(string: json[0]["url"].stringValue) {
                self.imgView.kf.setImage(with: imgUrl)
            }
        }
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

