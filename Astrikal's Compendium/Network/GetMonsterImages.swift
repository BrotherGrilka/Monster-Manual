//
//  GetMonsterImages.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 5/7/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import Foundation
import UIKit

final class GetMonsterImages: Network {
    init(forMonster monsterQuery: String, success dataCallback: @escaping DataCallback, failure failureCallback: @escaping ErrorCallback) {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "www.googleapis.com"
        components.path = "/customsearch/v1"
        components.queryItems = [
            URLQueryItem(name: "key", value: "AIzaSyA4NT_swnI5_4caRmu4bYZ93tLjBbqHAv8"),
            URLQueryItem(name: "cx", value: "003764051647235229870:dsqckkpmcvn"),
            URLQueryItem(name: "q", value: monsterQuery),
            URLQueryItem(name: "searchType", value: "image")
        ]

        var request = URLRequest(url: components.url!)
        
        request.httpMethod = HTTPMethod.GET
        
        super.init(request: request, callback: { (data, response, error) in
            guard error == nil else {
                failureCallback(error!)
                return
            }
            
            dataCallback(data)
        })
    }
}

extension UIImageView {
    func downloadImage(string: String) {
        let imageURL = URL(string: string)
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL!) else {
                // error
                return
            }

            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
