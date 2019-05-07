//
//  SplashViewController.swift
//  KatKat
//
//  Created by Zhaowei Wu on 5/7/19.
//  Copyright © 2019 Zhaowei Wu. All rights reserved.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    @IBOutlet weak var lottieContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()
    }
    
    private func playAnimation() {
        let animationView = AnimationView(name: "logo")
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        lottieContainerView.addSubview(animationView)
        animationView.play { (completed) in
            self.performSegue(withIdentifier: "showMain", sender: self)
        }
    }

}
