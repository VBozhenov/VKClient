//
//  DetailedNewsCellLayout.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 28/01/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

class DetailedNewsCellLayout: UICollectionViewLayout {
    
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var totalCellsHeight: CGFloat = 0
    private var totalCellsWidth: CGFloat = 0
    
    override func prepare() {
        self.cacheAttributes = [:]
        guard let collectionView = self.collectionView else {return}
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        guard itemsCount > 0 else {return}
        
        let cellWidth = collectionView.frame.width
        self.totalCellsHeight = cellWidth
        var lastX:CGFloat = 0
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: lastX, y: 0, width: cellWidth, height: cellWidth)
            lastX += cellWidth
            self.totalCellsWidth = lastX
            cacheAttributes[indexPath] = attributes
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in
            return rect.intersects(attributes.frame)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.totalCellsWidth, height: self.totalCellsHeight)
    }
    
    
}
