//
//  MonstaDetailHeaderView.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 7/12/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class MonstaDetailHeaderView: UITableViewHeaderFooterView {
    static let moniker = "MonstaDetailHeaderView"
    @IBOutlet weak var headerLabel:UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .mistyRose()
    }
}
