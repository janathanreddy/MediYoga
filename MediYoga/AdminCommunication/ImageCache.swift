//
//  ImageCache.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 07/12/20.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()
var imageURLString: String?

extension UIImageView{

func downloadImageFrom(urlString: String, imageMode: UIView.ContentMode) {
    guard let url = URL(string: urlString) else { return }
    downloadImageFrom(url: url, imageMode: imageMode)
}

func downloadImageFrom(url: URL, imageMode: UIView.ContentMode) {
    contentMode = imageMode
    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
        self.image = cachedImage
    } else {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data)
//                self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                self.image = imageToCache
            }
        }.resume()
    }
}
}
