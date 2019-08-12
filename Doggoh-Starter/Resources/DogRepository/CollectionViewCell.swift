//
//  CollectionViewCell.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 10/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelName: UILabel!
    // @IBOutlet weak var buttonCharachter: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.masksToBounds = true
    //    contentView.layer.borderColor = UIColor.orange.cgColor
        contentView.layer.cornerRadius = 22
    }
    override var isSelected: Bool {
        didSet {
            
            labelName.backgroundColor = isSelected ?  #colorLiteral(red: 0.9549426436, green: 0.439017117, blue: 0.2413057983, alpha: 1): #colorLiteral(red: 0.8974477649, green: 0.9018339515, blue: 0.9277464747, alpha: 1)
            if(isSelected){
             labelName.textColor = .white
            }
            else{
                labelName.textColor = #colorLiteral(red: 0.7510237098, green: 0.7645222545, blue: 0.8163567185, alpha: 1)
            }
        }
    }
    var nume: LabelStruct!{
        didSet{
            labelName.text = nume.name
        }
    }
    

}
