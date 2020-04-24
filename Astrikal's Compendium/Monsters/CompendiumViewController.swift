//
//  CompendiumViewController.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/16/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class CompendiumViewController: UIViewController {
    var errorScribe:ErrorScribe?

    override func viewDidLoad() {
        super.viewDidLoad()

        errorScribe = tabBarController as? ErrorScribe
    }
}
