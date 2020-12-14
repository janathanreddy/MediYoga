//
//  DoctorImageCache.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 08/12/20.
//

import Foundation
import UIKit
import Firebase

let imagecache = NSCache<NSString, AnyObject>()
var Spinner = UIActivityIndicatorView(style: .gray)
var Task:URLSessionDataTask!

extension UIImageView {

    func LoadImageUsingCacheWithUrlString(_ urlString: String) {
        self.image = nil
        addSpinner()
                    if let Task = Task{
                        Task.cancel()
                    }
        if let cachedImage = imagecache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            removeSpinner()

            return
        }

        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
        if let error = error {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imagecache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage

                }
            })
            
        }).resume()
    }
    
    func addSpinner(){
            addSubview(Spinner)
            Spinner.translatesAutoresizingMaskIntoConstraints = false
            Spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            Spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            Spinner.startAnimating()
        }
        func removeSpinner(){
            Spinner.stopAnimating()
            Spinner.removeFromSuperview()
        }
    
}
private func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
   let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
   let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
 
   let maxDimentionInPixels = max(pointSize.width, pointSize.height) * scale
 
   let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
 kCGImageSourceShouldCacheImmediately: true,
 kCGImageSourceCreateThumbnailWithTransform: true,
 kCGImageSourceThumbnailMaxPixelSize: maxDimentionInPixels] as CFDictionary
  let downsampledImage =     CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions)!
 
   return UIImage(cgImage: downsampledImage)
}
