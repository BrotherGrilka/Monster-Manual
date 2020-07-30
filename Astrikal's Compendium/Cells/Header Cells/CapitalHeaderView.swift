//
//  CapitalHeaderView.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 5/25/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class CapitalHeaderView: UITableViewHeaderFooterView {
    static let moniker = "CapitalHeaderView"
    @IBOutlet weak var indexCapital:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        indexCapital.textColor = Unicorn.lightSlateGray()
        contentView.backgroundColor = .mistyRose(alpha: 0.3)
    }
}
