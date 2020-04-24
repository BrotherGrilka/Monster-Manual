//
//  CompendiumTabBarController.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/16/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

enum CompendiumError:Error {
//    var Network = NetworkError(networkError: NetworkError)
}

protocol ErrorScribe {
    func recordInErrorScroll(status: NetworkError)
}

class CompendiumTabBarController: UITabBarController, ErrorScribe {    
    // MARK: - Error scribe delegate

    func recordInErrorScroll(status: NetworkError) {
        print("Compendium Error :: ", status)
    }
}
