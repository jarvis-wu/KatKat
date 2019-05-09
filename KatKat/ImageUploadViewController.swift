//
//  ImageUploadViewController.swift
//  KatKat
//
//  Created by Zhaowei Wu on 5/7/19.
//  Copyright © 2019 Zhaowei Wu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ImageUploadViewController: UIViewController {
    
    var img: UIImage!

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func didTapUploadButton(_ sender: Any) {
        activityIndicator.startAnimating()
        uploadImg()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        uploadButton.layer.cornerRadius = 10
        uploadButton.addShadow()
        cancelButton.layer.cornerRadius = 10
        cancelButton.addShadow()
        imgView.image = img
        activityIndicator.hidesWhenStopped = true
    }
    
    private func uploadImg() {
        let url = "https://api.thecatapi.com/v1/images/upload"
        let apiKey = "3d3a2d96-93b6-4b8e-bda4-2ddae0be237b"
        let imgData = img.pngData()!
        let _ = AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData, withName: "file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
        }, to: url, headers:["x-api-key": apiKey]).response { (res) in
            if let data = res.data, let json = try? JSON(data: data) {
                print(json)
                switch res.response?.statusCode {
                case 201:
                    self.showStatusLineMessage(message: "Your 🐱 is shared!")
                case 400:
                    let errMsg = json["message"].stringValue
                    self.showStatusLineMessage(message: errMsg)
                default:
                    self.showStatusLineMessage(message: "Oops, something went wrong.")
                }
            } else {
                self.showStatusLineMessage(message: "Check your internet buddy 😼")
            }
            self.activityIndicator.stopAnimating()
            self.navigationController?.popViewController(animated: true)
        }
    }

}
