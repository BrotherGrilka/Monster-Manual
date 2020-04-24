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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
