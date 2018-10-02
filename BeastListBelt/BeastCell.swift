//
//  BeastCell.swift
//  BeastListBelt
//
//  Created by Neil Sood on 9/21/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit

protocol BeastCellDelegate: class {
    func beastPressed(sender: BeastCell)
}

class BeastCell: UITableViewCell {
    
    @IBOutlet weak var beastButton: UIButton!
    @IBOutlet weak var beastLabel: UILabel!
    
    var indexPath: IndexPath?
    var delegate: BeastCellDelegate?
    
    @IBAction func beastPressed(_ sender: UIButton) {
        // add to beasted list
        // remove from tobeast list
        // reload table
        delegate?.beastPressed(sender: self)
    }
    
    
}
