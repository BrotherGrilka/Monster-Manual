//
//  MonstaCell.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 5/7/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class MonstaCell: UITableViewCell {
    static let moniker = "MonstaCell"
    @IBOutlet weak var monstaTableView:UITableView!
    @IBOutlet weak var monstaLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
