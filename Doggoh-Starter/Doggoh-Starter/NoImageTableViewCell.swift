//
//  NoImageTableViewCell.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class NoImageTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func config(_ dog: String){
        labelName.text =  dog
    }
}
