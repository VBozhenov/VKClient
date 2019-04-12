//
//  DataReloadable.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 11/04/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

protocol DataReloadable {
    func reloadRow(at indexPath: IndexPath)
}

extension UICollectionView: DataReloadable {
    func reloadRow(at indexPath: IndexPath) {
        reloadItems(at: [indexPath])
    }
}

extension UITableView: DataReloadable {
    func reloadRow(at indexPath: IndexPath) {
        reloadRows(at: [indexPath], with: .automatic)
    }
}
