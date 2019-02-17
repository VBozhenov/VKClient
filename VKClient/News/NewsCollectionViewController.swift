//
//  NewsCollectionViewController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 21/01/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "NewsFotoCell"


class NewsCollectionViewController: UICollectionViewController {
    
    static var newsNumber = 0
    let news = News()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.newsImages[NewsCollectionViewController.newsNumber].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewsCollectionViewCell
        cell.newsFotoImage.image = UIImage(named: news.newsImages[NewsCollectionViewController.newsNumber][indexPath.row])
        
        return cell
    }
}
