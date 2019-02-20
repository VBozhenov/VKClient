//
//  DetailedFriendFotoViewController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 13/02/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import Kingfisher

class DetailedFriendFotoViewController: UICollectionViewController {
    
    var userId = 0
    var photos = [Photo]()
    var indexToScrollTo = IndexPath()
    let networkService = NetworkService()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.loadFriendsFoto(for: userId) { [weak self] photos, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let photos = photos, let self = self {
                self.photos = photos
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: true)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendFotoImage", for: indexPath) as! DetailedFriendFotoCell
        if let photo = photos[indexPath.row].photo {
            cell.friendFoto.kf.setImage(with: URL(string: photo))
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 1) {
            cell.alpha = 1
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteriteSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
