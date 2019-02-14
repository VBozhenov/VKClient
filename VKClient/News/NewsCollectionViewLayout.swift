//
//  NewsCollectionViewLayout.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 24/01/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

class NewsCollectionViewLayout: UICollectionViewLayout {

    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    var columnsCount = 2
    private var totalCellsHeight: CGFloat = 0
    
    override func prepare() {
        self.cacheAttributes = [:]
        guard let collectionView = self.collectionView else {return}
        let itemsCount = collectionView.numberOfItems(inSection: 0) < 4 ? collectionView.numberOfItems(inSection: 0) : 4
        guard itemsCount > 0 else {return}
        
        let bigCellWidth = collectionView.frame.width
        let smallCellWidth = collectionView.frame.width / CGFloat(self.columnsCount)
        
        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        
        switch itemsCount {
        case 1:
            let index = 0
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: 0, y: lastY, width: bigCellWidth, height: bigCellWidth)
            lastY += bigCellWidth
            cacheAttributes[indexPath] = attributes
            self.totalCellsHeight = lastY
        case 2:
            for index in 0..<itemsCount {
                let indexPath = IndexPath(item: index, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: 0, y: lastY, width: bigCellWidth, height: bigCellWidth / 2)
                lastY += bigCellWidth / 2
                cacheAttributes[indexPath] = attributes
                self.totalCellsHeight = lastY
            }
        case 3:
            for index in 0..<itemsCount {
                let indexPath = IndexPath(item: index, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let isBigCell = (index + 1) % (self.columnsCount + 1) == 0
                
                if isBigCell {
                    attributes.frame = CGRect(x: 0, y: lastY, width: bigCellWidth, height: bigCellWidth / 2)
                    lastY += bigCellWidth / 2
                } else {
                    attributes.frame = CGRect(x: lastX, y: lastY, width: smallCellWidth, height: bigCellWidth / 2)
                    let isLastColumn = (index + 2) % (self.columnsCount + 1) == 0 || index == itemsCount - 1
                    if isLastColumn {
                        lastX = 0
                        lastY += bigCellWidth / 2
                    } else {
                        lastX += smallCellWidth
                    }
                }
                cacheAttributes[indexPath] = attributes
                self.totalCellsHeight = lastY
                
            }
        default:
            for index in 0..<itemsCount {
                let indexPath = IndexPath(item: index, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                attributes.frame = CGRect(x: lastX, y: lastY, width: smallCellWidth, height: bigCellWidth / 2)
                let isLastColumn = (index + 2) % (self.columnsCount + 1) == 0 || index == itemsCount - 1
                if isLastColumn {
                    lastX = 0
                    lastY += bigCellWidth / 2
                } else {
                    lastX += smallCellWidth
                }
                
                cacheAttributes[indexPath] = attributes
                self.totalCellsHeight = lastY
            }
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
        return CGSize(width: self.collectionView?.frame.width ?? 0, height: self.totalCellsHeight)
    }
    
    
}
