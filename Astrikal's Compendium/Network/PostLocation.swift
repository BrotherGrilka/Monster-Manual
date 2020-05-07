//
//  PostLocation.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/28/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import Foundation

final class PostLocation: Network {
    init(withURL url: URL, data: Data, success dataCallback: @escaping DataCallback, failure failureCallback: @escaping ErrorCallback) {
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.POST
        request.httpBody = data
        
        super.init(request: request, callback: { (data, response, error) in
            guard error == nil else {
                failureCallback(error!)
                return
            }
        
            dataCallback(data)
        })
    }
}
