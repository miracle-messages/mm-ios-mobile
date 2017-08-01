//
//  CaseTableViewCell.swift
//  MiracleMessages
//
//  Created by Win Raguini on 7/31/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import Nuke

class CaseTableViewCell: UITableViewCell {

    @IBOutlet weak var caseRecordDate: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var caseImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with aCase: CaseSummary)  {
        let name = aCase.name
        clientName.text = "\(name)"
        let url = URL(string: aCase.imageUrl)
        Nuke.loadImage(with: url!, into: caseImageView)
        caseImageView.layer.cornerRadius = caseImageView.frame.size.height/2
    }

}
