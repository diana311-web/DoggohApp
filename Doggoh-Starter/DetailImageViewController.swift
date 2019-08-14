//
//  DetailImageViewController.swift
//  
//
//  Created by Elena Gaman on 14/08/2019.
//

import UIKit

class DetailImageViewController: UIViewController {
    
    @IBOutlet weak var ImageDogsCollections: UICollectionView!
    var dogName : String!
    var imgNumber: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = dogName.uppercased()
        navigationController?.isNavigationBarHidden = false
//        imgReceive = imgNumber
        ImageDogsCollections.delegate = self
        ImageDogsCollections.dataSource = self
        ImageDogsCollections.register(UINib(nibName: "DetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DetailCollectionViewCell")
        
    }
}
extension DetailImageViewController: UICollectionViewDelegateFlowLayout {
        
}
extension DetailImageViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        cell.config(nameImage: imgNumber)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let cellSize = CGSize(width: collectionView.frame.width * 2
            ,height:  collectionView.frame.height * 2)
        return cellSize
    }
    
    
}
    

