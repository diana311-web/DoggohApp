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
        tableView.rowHeight = 86
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
            
            //print(dogs)
            
            
            dogs.forEach { (key, value) in
                
                let dog = Doggye(breed: key, subBreeds: value)
                dogsArray.append(dog)
                
            }
            
            //print(dogsArray)
            for dog in dogsArray {
               
          //      if dog.subBreeds?.count ?? 0 > 0
              //  {
                    dogsBread.append(dog.breed)
                 
            //    }
                
            }
            
          //  dogsBread.append("")
             dogsBread.sort()
         //   print(dogsBread)
        }
      
      //  navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return dogsBread.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = dogsBread[section]
        let subbreeds = dogs[sectionKey]
    //    return (dog?.count ?? 0 > 0 ? dog!.count + 1 : 1)
        
//        if section == dogsBread.count - 1 {
//            return dogs.filter({ $0.value.count == 0}).count
//        }
     //  print ("subreeds in number", subbreeds)
       return subbreeds?.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let simpleDogs = dogs.filter{ $0.value.count == 0}.map { $0.key}
        print(simpleDogs)
        let sectionKey = dogsBread[indexPath.section]
        let subbreeds = dogs[sectionKey]
       // if indexPath.section == dogsBread.count - 1 {
    //    print ("subreeds", dogsArray[indexPath.section].subBreeds?.count)
     // if dogsArray[indexPath.section].subBreeds?.count == 0
       // print ("lista ",dogsArray[indexPath.section].breed)
        print("subbreeds", subbreeds)
        if  subbreeds?.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
            cell.config(simpleDogs[indexPath.row], String(Int.random(in: 0..<23)))
            cell.separatorInset = UIEdgeInsets(top: 0, left: 89, bottom: 0, right:0)
            print ("intru aici")
            return cell

        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dogIdentifier", for: indexPath) as! TableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            let section = dogsBread[indexPath.section]
            let subbreeds =  dogs[section]
            cell.config(subbreeds?[indexPath.row] ?? "",  String(Int.random(in: 0..<23)))
        
            return cell
            

        }
//        if dogsArray[indexPath.section].subBreeds?.count == 0{
//              let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
//            cell.config(dogsArray[indexPath.section].breed.uppercased(), String(Int.random(in: 0..<23)))
//            return cell
//        }
//        else {
//
//
//           let row = indexPath.row
//
//            if row == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "noImageTableViewCell", for: indexPath) as! NoImageTableViewCell
//                cell.config(dogsBread[indexPath.section].uppercased())
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "dogIdentifier", for: indexPath) as! TableViewCell
//                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
//                cell.config(dogsArray[indexPath.section].subBreeds![row-1],  String(Int.random(in: 0..<23)))
//                return cell
//            }
//        }
//
        
    }
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
      
     
            
        let sectionKey = dogsBread[section]
        let subbreeds = dogs[sectionKey]
     
//            if dogsArray[section].subBreeds?.count == 0{
//                titleLabel.text = ""
//            }
//            else
//            {
//                print ("am intrat pe else")
//                print (dogsArray[section].subBreeds)
            let  sectionHeader = UIView()
            var titleLabel = UILabel()
            if subbreeds?.count == 0{
            //    sectionHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 80))
                titleLabel = UILabel(frame: sectionHeader.bounds)
                titleLabel.text = dogsBread[section].uppercased()
                titleLabel.font = UIFont(name: "Montserrat-Bold", size: 14)
                titleLabel.frame = CGRect(x: 89, y: 30, width: tableView.frame.size.width-20, height: 20)
                let imageView = UIImageView(frame: CGRect(x: 35, y: 25, width: 40, height: 40)); // set as you want
                let image = UIImage(named: String(Int.random(in: 0..<23)))
                imageView.image = image
                sectionHeader.addSubview(imageView)
                sectionHeader.addSubview(titleLabel)
                
            }
        else{
           
           //     sectionHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
                titleLabel =  UILabel(frame: sectionHeader.bounds)
                titleLabel.font = UIFont(name: "Montserrat-Bold", size: 14)
                titleLabel.textAlignment = .left
                titleLabel.frame = CGRect(x: 89, y: 10, width: tableView.frame.size.width-20, height: 20)
                titleLabel.text = dogsBread[section].uppercased()
                sectionHeader.addSubview(titleLabel)
            }
            
        return sectionHeader
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print (dogsArray[indexPath.row])
    }
}
