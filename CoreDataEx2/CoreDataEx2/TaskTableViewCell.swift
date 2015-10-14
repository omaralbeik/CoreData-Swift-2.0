//
//  TaskTableViewCell.swift
//  CoreDataEx2
//
//  Created by Omar Albeik on 12/10/15.
//  Copyright © 2015 Omar Albeik. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var descritptionTextLabel: UILabel!
    @IBOutlet weak var dueDateTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
