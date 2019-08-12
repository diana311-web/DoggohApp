//
//  DogCollectionViewCell.swift
//  CollectionViewExample
//
//  Created by George Galai on 08/08/2019.
//  Copyright © 2019 George Galai. All rights reserved.
//

import UIKit

class DogCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dogImageView: UIImageView!

    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    override var isSelected: Bool {
        didSet {
            dogImageView.layer.borderWidth = isSelected ? 5 : 0
        }
    }

    var dog: Dog! {
        didSet {
            dogImageView.image = dog.image
            dogNameLabel.text = dog.name
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        dogImageView.layer.cornerRadius = 22
        containerView.layer.masksToBounds = true
        dogImageView.layer.borderColor = UIColor.orange.cgColor

//        isSelected = false
    }

}
