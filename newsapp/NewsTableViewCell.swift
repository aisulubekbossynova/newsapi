//
//  NewsTableViewCell.swift
//  newsapp
//
//  Created by aisulubekbossynova on 7/24/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var vidlbl: UILabel!
    @IBOutlet weak var vidimg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
