//
//  DetailCollectionViewCell.swift
//  
//
//  Created by Elena Gaman on 14/08/2019.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var detailImageCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config (nameImage: String){
        detailImageCell.image = UIImage(named: nameImage)
    }
    
}
