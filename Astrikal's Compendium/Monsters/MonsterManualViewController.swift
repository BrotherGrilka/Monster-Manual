//
//  MonsterManualViewController.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/16/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class MonsterManualViewController: UIViewController {
    var errorScribe:ErrorScribe?

    override func viewDidLoad() {
        super.viewDidLoad()

        errorScribe = navigationController as? ErrorScribe
    }
}
