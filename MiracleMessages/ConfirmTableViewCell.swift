//
//  ReviewTableViewCell.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 7/26/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class ConfirmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
