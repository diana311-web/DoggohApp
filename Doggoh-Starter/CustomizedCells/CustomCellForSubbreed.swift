//
//  TableViewCell.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class CustomCellForSubbreed: UITableViewCell {

    @IBOutlet weak var imagedog: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //private var dog : Dog
    
    func config(_ dog: String,_ image: UIImage){
        imagedog.image = image
        labelName.text =  dog
        
    }
    var viewModel : CustomCellForSubbreedModel!{
        didSet{
            imagedog.image = UIImage(data:  viewModel.imageDog as Data)
            labelName.text = viewModel.nameDog
        }
    }
  
}
