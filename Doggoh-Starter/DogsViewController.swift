//
//  DogsViewController.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DogsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    private var sectionTitles = [String]()
    let contactReuseIdentifier = "dog"
    var nrsection = 0
    var dogsArray = [Doggye]()
    var dogs : [String:[String]] = [:]
    var dogsBread=[String]()
    var pozaIndex = String("0")
    
    override func viewDidLoad() {
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: "TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "dogIdentifier")
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomTableViewCell")
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = true
        //  print (dogs)
        if let json = BreedsRepository.dataFromJSON(withName: BreedsRepository.statementsFilename) {
            
            dogs = json["message"] as! [String : [String]]
            
            
            dogs.forEach { (key, value) in
                
                let dog = Doggye(breed: key, subBreeds: value)
                dogsArray.append(dog)
                
            }
        
       dogsArray.sort{ $0.breed < $1.breed }
            
    }
        
}
    override func viewWillAppear(_ animated: Bool) {
          navigationController?.isNavigationBarHidden = true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dogsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let nr = dogsArray[section].subBreeds?.count, nr != 0
        {
            
            return nr
        }
        else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dogsArray[indexPath.section].subBreeds?.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
            cell.config(dogsArray[indexPath.section].breed,String(indexPath.section%23))
                
      //      print ("index:",dogsArray[indexPath.section].breed.count)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 89, bottom: 0, right:0)
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dogIdentifier", for: indexPath) as! TableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            
            cell.config(dogsArray[indexPath.section].subBreeds![indexPath.row] ,  "\(indexPath.row%23)")
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        
        let  sectionHeader = UIView()
        let titleLabel =  UILabel(frame: sectionHeader.bounds)
        sectionHeader.addSubview(titleLabel)
        
        if dogsArray[section].subBreeds?.count == 0{
        
          return UIView(frame: CGRect.zero)
            
        }
        else
        {
            titleLabel.font = UIFont(name: "Montserrat-Bold", size: 14)
            titleLabel.textAlignment = .left
            titleLabel.frame = CGRect(x: 89, y: 0, width: tableView.frame.size.width-20, height: 20)
            titleLabel.text = dogsArray[section].breed.uppercased()
            return sectionHeader
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if dogsArray[section].subBreeds?.count == 0{
            let footer = UIView()
            let footerView = UIView(frame: CGRect(x: 89, y: 0, width:  tableView.frame.size.width, height: 2))
            footerView.backgroundColor = #colorLiteral(red: 0.9426903725, green: 0.9571765065, blue: 0.9741945863, alpha: 1)
            footer.addSubview(footerView)
            return footer
        }
        return UIView(frame: CGRect.zero)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if dogsArray[indexPath.section].subBreeds?.count == 0{
            print (dogsArray[indexPath.section].breed.uppercased())
              performSegue(withIdentifier: "tranzitie", sender: dogsArray[indexPath.section].breed)
            
        }
        else {
            print ( dogsArray[indexPath.section].subBreeds![indexPath.row] )
              performSegue(withIdentifier: "tranzitie", sender:  dogsArray[indexPath.section].subBreeds![indexPath.row] )
        }
          pozaIndex = String(indexPath.section%23)
        tableView.deselectRow(at: indexPath, animated: true)
  //      pozaIndex = "\(indexPath.row%5)"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let infoTableVC = segue.destination as!  DetailImageViewController
        infoTableVC.dogName = sender as? String
        print ("pozaIndex", pozaIndex)
        infoTableVC.imgNumber = pozaIndex
        }
}

