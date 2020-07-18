//
//  NetworkClient.swift
//  MoviesApp
//
//  Created by admin on 18/07/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit

class NetworkClient: NSObject {
    let cache = NSCache<NSString, UIImage>()
    
    func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            return closure(nil)
        }
        let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                return closure(nil)
            }
            guard response != nil else {
                print("no response")
                return closure(nil)
            }
            guard data != nil else {
                print("no data")
                return closure(nil)
            }
            
            // To cache the downloaded image
            var downloadedImage: UIImage?
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            if downloadedImage != nil {
                self.cache.setObject(downloadedImage!, forKey: urlString as NSString)
            }
            DispatchQueue.main.async {
                closure(UIImage(data: data!))
            }
        }; task.resume()
    }
    
    // This function first checks if there is a image available in the cache before downloading it.
    func getImage(_ urlString: String, closure: @escaping (UIImage?) -> ()) {
        print("get image called..")
        if let image = cache.object(forKey: urlString as NSString) {
            closure(image)
        } else {
            getImageFromWeb(urlString, closure: closure)
        }
    }

    func fetchMovieList(completed: @escaping (MovieResults?) -> () )
    {
        let url = URL(string: Constant.TRENDING_MOVIE_URL)
        URLSession.shared.dataTask(with: url!) {
            (data, response, err) in
            if err == nil {
                guard let jsondata = data else {
                    print("Error: ", err!)
                    completed(nil)
                    return
                }
                do {
                    let results = try JSONDecoder().decode(MovieResults.self, from: jsondata)
                    DispatchQueue.main.async {
                        completed(results)
                    }
                } catch {
                    print("JSON Downloading Error!")
                }
            }
        }.resume()
    }
}

