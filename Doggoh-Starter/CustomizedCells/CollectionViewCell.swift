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
    @IBOutlet weak var containerView: UIView!
    // @IBOutlet weak var buttonCharachter: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    static var count = 0
    override var isSelected: Bool {
        didSet {
          
            if ( CollectionViewCell.count <= 3){
                  CollectionViewCell.count += 1
              //  print(CollectionViewCell.count)
                labelName.backgroundColor =  #colorLiteral(red: 0.9549426436, green: 0.439017117, blue: 0.2413057983, alpha: 1)
                containerView.backgroundColor = #colorLiteral(red: 0.9549426436, green: 0.439017117, blue: 0.2413057983, alpha: 1)
                if(isSelected){
                    labelName.textColor = .white
                }
                else{
                    labelName.textColor = #colorLiteral(red: 0.7510237098, green: 0.7645222545, blue: 0.8163567185, alpha: 1)
                }
            }
            if ( isSelected == false ) {
                CollectionViewCell.count -= 1
                labelName.backgroundColor = #colorLiteral(red: 0.8974477649, green: 0.9018339515, blue: 0.9277464747, alpha: 1)
                containerView.backgroundColor = #colorLiteral(red: 0.8974477649, green: 0.9018339515, blue: 0.9277464747, alpha: 1)
                labelName.textColor = #colorLiteral(red: 0.7510237098, green: 0.7645222545, blue: 0.8163567185, alpha: 1)
            }
            }
           
    }
    var nume: LabelStruct!{
        didSet{
            labelName.text = nume.name
            setNeedsLayout()
            layoutIfNeeded()
            containerView.layer.cornerRadius = containerView.bounds.height/2.0
        }
    }
    

}
