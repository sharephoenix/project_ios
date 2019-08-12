//
//  YSMainCell.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/12.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class YSMainCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setModel(_ model: YSMainViewModel) {
        self.nameLabel.text = model.name
    }
}

struct YSMainViewModel {
    let name: String?
}
