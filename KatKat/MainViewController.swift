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
    
    @IBAction func didTapPlusButton(_ sender: Any) {
        uploadPhoto()
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
        let url = "https://api.thecatapi.com/v1/images/search"
        AF.request(url).responseData { dataRes in
            if let data = dataRes.data, let json = try? JSON(data: data), let imgUrl = URL(string: json[0]["url"].stringValue) {
                self.imgView.kf.setImage(with: imgUrl)
            }
        }
    }
    
    private func uploadPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image"]
        present(pickerController, animated: true)
    }
    
    private func reachabilityDidChange(connection: Reachability.Connection) {
        var message = "Welcome back online!"
        switch connection {
        case .cellular:
            message = "Using cellular data. Watch out!"
        case .wifi:
            message = "Welcome back online!"
        case .none:
            message = "You are offline. No more cats :<"
        }
        showStatusLineMessage(message: message)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageUploader" {
            let vc = segue.destination as! ImageUploadViewController
            vc.img = sender as? UIImage
            vc.navigationItem.hidesBackButton = true
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

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.performSegue(withIdentifier: "showImageUploader", sender: image)
        }
    }
}

extension UIViewController {
    func showStatusLineMessage(message: String) {
        let messageView = MessageView.viewFromNib(layout: .statusLine)
        messageView.configureContent(body: message)
        messageView.layoutMarginAdditions = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        messageView.addShadow()
        SwiftMessages.show(view: messageView)
    }
}

