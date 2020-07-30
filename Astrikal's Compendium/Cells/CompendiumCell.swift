//
//  CompendiumCell.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/15/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class CompendiumCell: UITableViewCell {
    static let moniker = "CompendiumCell"
    @IBOutlet weak var entry:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        let backgroundView = UIView()
        backgroundView.backgroundColor = .mistyRose(alpha: 0.3)
        selectedBackgroundView = backgroundView
    }
}
