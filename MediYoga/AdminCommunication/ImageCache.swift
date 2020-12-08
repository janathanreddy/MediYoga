//
//  ImageCache.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 07/12/20.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()
var spinner = UIActivityIndicatorView(style: .gray)
var task:URLSessionDataTask!

extension UIImageView {

    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        self.image = nil
        addspinner()
                    if let task = task{
                        task.cancel()
                    }
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            removespinner()

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
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage

                }
            })
            
        }).resume()
    }
    
    func addspinner(){
            addSubview(spinner)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            spinner.startAnimating()
        }
        func removespinner(){
            spinner.removeFromSuperview()
        }
    
}
