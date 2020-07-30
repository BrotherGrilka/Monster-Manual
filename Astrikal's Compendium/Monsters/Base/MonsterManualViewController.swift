//
//  MonsterManualViewController.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/16/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class MonsterManualViewController: UIViewController {
    var scribe:Scribe?

    override func viewDidLoad() {
        super.viewDidLoad()

        scribe = navigationController as? Scribe
    }
}
