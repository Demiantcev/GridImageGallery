//
//  MyImageView.swift
//  GridGallery
//
//  Created by Кирилл Демьянцев on 01.05.2023.
//

import UIKit

class MyImageView: UIImageView {
    
    static let catchImage = NSCache<NSString, UIImage>()
    
    static func downloadImage(withURL url : URL, completion : @escaping (UIImage?) -> ()) {
        
        let dataTask = URLSession.shared.dataTask(with: url) {data, urlData, error in
            var downloadImage : UIImage?
            if let data = data {
                downloadImage = UIImage(data: data)
            }
            if downloadImage != nil {
                catchImage.setObject(downloadImage!, forKey: url.absoluteString as NSString)
            }
            DispatchQueue.main.async {
                completion(downloadImage)
            }
        }
        dataTask.resume()
    }
    
    func getImage(withURL url : URL, completion : @escaping (UIImage?) -> ()) {
        
        if let image = MyImageView.catchImage.object(forKey: url.absoluteString as NSString) {
            completion(image)
            
        } else {
            MyImageView.downloadImage(withURL: url, completion: completion)
        }
    }
}
