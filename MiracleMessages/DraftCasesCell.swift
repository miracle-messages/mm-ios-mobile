//
//  DraftCasesCell.swift
//  MiracleMessages
//
//  Created by Ved on 05/12/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class DraftCasesCell: UITableViewCell {

    @IBOutlet weak var lblCaseSubmittedOn: UILabel!
    @IBOutlet weak var lblCaseStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
