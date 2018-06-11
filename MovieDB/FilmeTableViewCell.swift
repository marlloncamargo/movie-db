//
//  FilmeTableViewCell.swift
//  MovieDB
//
//  Created by PUCPR on 21/05/16.
//  Copyright © 2016 PUCPR. All rights reserved.
//

import UIKit

class FilmeTableViewCell: UITableViewCell {


    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var filmeAno: UILabel!
    @IBOutlet weak var filmeName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
