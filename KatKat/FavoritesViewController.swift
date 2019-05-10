//
//  FavoritesViewController.swift
//  KatKat
//
//  Created by Zhaowei Wu on 5/9/19.
//  Copyright © 2019 Zhaowei Wu. All rights reserved.
//

import UIKit
import Kingfisher

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var favorites = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favorites = UserDefaults.standard.stringArray(forKey: "favorites") ?? [String]()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoritesCollectionViewCell
        cell.imgView.kf.setImage(with: URL(string: favorites[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // more actions: see large image, save image, unlike, share...
    }
    
    // TODO: sizeForItem, etc...


}
