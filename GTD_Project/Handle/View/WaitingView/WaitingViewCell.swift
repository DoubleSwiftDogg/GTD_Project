//
//  WaitingViewCell.swift
//  GTD_Project
//
//  Created by MacBook on 23/03/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import UIKit

class WaitingViewCell: UITableViewCell {
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskExecutorLabel: UILabel!
    @IBOutlet weak var taskTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
