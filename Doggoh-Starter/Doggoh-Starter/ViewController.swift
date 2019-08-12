//
//  ViewController.swift
//  Doggoh-Starter
//
//  Created by Razvan Apostol on 02/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var colectionView: UICollectionView!
    @IBOutlet weak var textName: UITextField!
    var nameForDogsPicker = UIPickerView()
    var savedName : String = ""
    
    var dogs :[String] = ["Husky",
                         "Keeshond",
                         "Kelpie",
                         "Komondor",
                         "Kuvasz",
                         "Labrador",
                         "Leonberg",
                        ]
    var selectedItems = [String]()
    var nameButoons = ["QUIET", "CHEERFULL", "ACTIVE","PLAYFUL", "LOUD","CURIOUS", "PEACEFUL", "FRIENDLY"]
    override func viewDidLoad() {
        super.viewDidLoad()
        nameForDogsPicker.isHidden = false
        nameForDogsPicker.delegate = self
        nameForDogsPicker.dataSource = self
        colectionView.delegate = self
        colectionView.dataSource = self
        colectionView.register(UINib(nibName: "CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CollectionViewCell")
    //    self.view.addSubview(nameForDogsPicker)
        // Do any additional setup after loading the view.
        textName.attributedPlaceholder = NSAttributedString(string: "American Alaskan Malamute", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        colectionView.allowsMultipleSelection = true
         configureDatePicker()
    }

    
    @IBAction func buttonPressed(_ sender: Any) {
        print("button pressed")
        textName.isUserInteractionEnabled = true
    //    nameForDogsPicker?.isHidden = !nameForDogsPicker!.isHidden
      
        
        
    }
    
    func configureDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let savBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnClicked))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([savBtn,flexibleSpace,cancelBtn], animated: true)
        colectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:))))
        textName.inputView = nameForDogsPicker
        textName.inputAccessoryView = toolbar
        
    }
    @objc func saveBtnClicked(){
        print ("Save clicked value ")
        textName.alpha = 1
        savedName = textName.text ?? ""
    }
    @objc func cancelBtnClicked(){
        print ("Cancel clicked")
        textName.alpha = 1
        textName.text = savedName
        self.view.endEditing(true)
    }
    @objc func handleLongGesture(gesture:UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = colectionView.indexPathForItem(at: gesture.location(in: colectionView))
                else { break }
            colectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            colectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            colectionView.endInteractiveMovement()
        default:
            colectionView.cancelInteractiveMovement()
        }
    }
   
}
extension ViewController:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textName.alpha = 0.5
        textName.text = dogs[row]
    }
}
extension ViewController:UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dogs[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dogs.count
    }
    
    
}
extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
                let width = (collectionView.frame.size.width - 32 - collectionView.contentInset.left - collectionView.contentInset.right) / 3
               let height: CGFloat = 48

                return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let btn = nameButoons[indexPath.row]
        selectedItems.append(btn)
        print(selectedItems)
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let btn = nameButoons[indexPath.row]
        print (btn)
        guard let index = selectedItems.firstIndex(of: btn) else {
            return
        }
        selectedItems.remove(at: index)
        
        print("Deselect",indexPath.row)
    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        colectionView.reloadData()
//    }
   
    
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameButoons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let word = nameButoons[indexPath.row]
        
        let btn = LabelStruct(name: word)
        cell.nume = btn
        
        if selectedItems.contains(word){
            cell.isSelected = false
        }
       
        return cell
    }
    
    
}
