//
//  PhotoService.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 11/04/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import Alamofire

class PhotoService {
    
    private var images = [String: UIImage]()
    private let cacheLifetime: TimeInterval = 60*60*24*7
    private let container: DataReloadable
    
    init<T: DataReloadable>(container: T) {
        self.container = container
    }
    
    private static let pathName: String = {
        let pathName = "images"
        
        guard let cacheDir = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cacheDir.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private func getFilePath(urlString: String) -> String? {
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hashName = String(describing: urlString.hashValue)
        
        return cacheDir.appendingPathComponent(PhotoService.pathName + "/" + hashName).path
    }
    
    private func saveImageToCache(urlString: String, image: UIImage) {
        guard let filename = getFilePath(urlString: urlString) else { return }
        
        let data = image.pngData()
        FileManager.default.createFile(atPath: filename, contents: data, attributes: nil)
    }
    
    private func getImageFromCache(urlString: String) -> UIImage? {
        guard let filename = getFilePath(urlString: urlString),
            let info = try? FileManager.default.attributesOfItem(atPath: filename),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return nil }
        
        let lifetime = Date().timeIntervalSince(modificationDate)
        
        guard lifetime <= cacheLifetime,
            let image = UIImage(contentsOfFile: filename) else { return nil }
        
        images[urlString] = image
        return image
    }
    
    private func loadPhoto(at indexPath: IndexPath, by urlString: String) {
        Alamofire.request(urlString).responseData { [weak self] response in
            guard let self = self,
                let data = response.data,
                let image = UIImage(data: data) else { return }
            
            self.images[urlString] = image
            self.saveImageToCache(urlString: urlString, image: image)
            
            DispatchQueue.main.async {
                self.container.reloadRow(at: indexPath)
            }
        }
    }
    
    public func photo(at indexPath: IndexPath, by urlString: String) -> UIImage? {
        if let photo = images[urlString] {
            return photo
        } else if let photo = getImageFromCache(urlString: urlString) {
            return photo
        } else {
            loadPhoto(at: indexPath, by: urlString)
        }
        
        return nil
    }
}
