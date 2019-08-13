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
    
    override func viewDidLoad() {
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: "TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "dogIdentifier")
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomTableViewCell")
        tableView.register(UINib(nibName: "NoImageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "noImageTableViewCell")
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
            cell.config(dogsArray[indexPath.section].breed, String(Int.random(in: 0..<23)))
            cell.separatorInset = UIEdgeInsets(top: 0, left: 89, bottom: 0, right:0)
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dogIdentifier", for: indexPath) as! TableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            
            cell.config(dogsArray[indexPath.section].subBreeds![indexPath.row] ,  String(Int.random(in: 0..<23)))
            
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
        }
        else {
            print ( dogsArray[indexPath.section].subBreeds![indexPath.row] )
        }
        
    }
}

