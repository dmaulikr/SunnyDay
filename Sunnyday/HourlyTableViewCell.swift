//
//  HourlyTableViewCell.swift
//  Sunnyday
//
//  Created by Parth on 5/24/17.
//  Copyright © 2017 Bhoiwala. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var HourlyCondition: UILabel!
    @IBOutlet weak var HourlyIcon: UIImageView!
    @IBOutlet weak var HourlyTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
