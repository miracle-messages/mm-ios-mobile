//
//  ReviewTableViewCell.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 7/26/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    var reviewable: Reviewable? {
        didSet {
            guard let this = reviewable else { return }
            labelName.text = this.fullName
            labelInfo.text = this.reviewDescription
        }
    }
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelInfo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
