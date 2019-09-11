//
//  ViewController.swift
//  CollectionViewExample
//
//  Created by George Galai on 08/08/2019.
//  Copyright © 2019 George Galai. All rights reserved.
//

import UIKit
import CoreData


class ViewControllerCollections: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gradientView: UIView!

    var dogs = DogDataModel.allDogs()
     var dogFR : Dog!
    let defaultSpace: CGFloat = 8
    let numberOfColumns: CGFloat = 2
    var viewModel : ViewControllerCollectionsModel!
    var selectedItems = [DogDataModel]()
    let dogsModel = [DogDataModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradientView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "DogCollectionViewCellClass", bundle: Bundle.main), forCellWithReuseIdentifier: "DogCollectionViewCell")
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:))))
        collectionView.allowsMultipleSelection = true
        
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
     // deleteAllData(entity: "Dog")
        
        viewModel = ViewControllerCollectionsModel(withDogs: dogs)
        viewModel.addDogs()
    }
    
    
    fileprivate func addGradientView() {
        let gradientHeight = gradientView.frame.origin.y + gradientView.frame.size.height - collectionView.frame.origin.y
        collectionView.contentInset = UIEdgeInsets(top: gradientHeight, left: 2 * defaultSpace, bottom: defaultSpace, right: 2 * defaultSpace)
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0.84).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor]
        gradient.locations =  [0.0, 1.0]
        gradient.frame = gradientView.bounds
        
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc func handleLongGesture(gesture:UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView))
                else { break }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}

extension ViewControllerCollections: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
      //  return dogs[indexPath.item].image.size.height
        return viewModel.heightForPhoto(atIndex: indexPath.item)
    }
}

extension ViewControllerCollections: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return defaultSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return defaultSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      
//        let aux = dogs.remove(at: sourceIndexPath.item)
//        dogs.insert(aux, at: destinationIndexPath.item)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //  let dog = dogs[indexPath.row]
        let doggye = viewModel.fetchRC.object(at: indexPath)
        let dog = DogDataModel(image: UIImage(data: doggye.image as! Data)!, name: doggye.name!)
        selectedItems.append(dog)
        print(selectedItems)
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let dog = dogs[indexPath.row]
        guard let index = selectedItems.firstIndex(of: dog) else {
            return
        }
        selectedItems.remove(at: index)
        print(indexPath.row)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionView.reloadData()
    }
}

extension ViewControllerCollections: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfDogsInSection()
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogCollectionViewCell", for: indexPath) as! DogCollectionViewCellClass
        let doggye = viewModel.fetchRC.object(at: indexPath)
        let dog = DogDataModel(image: UIImage(data: doggye.image as! Data)!, name: doggye.name!)
        cell.dog = dog
        if(selectedItems.contains(cell.dog)) {
            cell.isSelected = true
        }
        
        return cell
    }
}
