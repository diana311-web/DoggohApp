//
//  CustomTableViewCell.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class CustomCellForBreed: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageDog: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(_ dog: String,_ image: UIImage){
        labelName.text =  dog.uppercased()
        imageDog.image = image
    }
    var viewModel : CustomCellForBreedModel!{
        didSet{
            imageDog.image = UIImage(data:  viewModel.breedImage as Data)
            labelName.text = viewModel.breedName
        }
    }
    
}
