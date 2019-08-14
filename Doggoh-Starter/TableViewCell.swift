//
//  TableViewCell.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imagedog: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //private var dog : Dog
    
    func config(_ dog: String,_ image: String){
        imagedog.image = UIImage(named: image)
        labelName.text =  dog
        
    }
  
}
