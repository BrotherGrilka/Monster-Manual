//
//  MonstaTraitView.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 6/20/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class MonstaTraitView: UIView {
    @IBOutlet weak var traitLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var descriptionTextView:UITextView!
    @IBOutlet weak var traitIndentation: NSLayoutConstraint!
    @IBOutlet weak var descriptionIndentation: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
