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
    
    let apiClient2 = DogAPI2Client.sharedInstance
    private var sectionTitles = [String]()
    var dogsArray = [Doggye]()
    var dogs : [String:[String]] = [:]
    var dogsImage = [String : UIImage]()
    var images = [UIImage]()
    var pozaIndex = String("0")
    //-------------
    var activityIndicator = UIActivityIndicatorView()
    let apiClient = DogAPIClient.sharedInstance
    //--------------
    override func viewDidLoad() {
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: "TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "dogIdentifier")
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomTableViewCell")
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = true
        configActivityIndicator()
        testNetworkCalls()
    }
    var data = Data()
    var imageView = UIImageView()
    public func testNetworkCalls() {
        showActivityIndicatory()
        apiClient.getAllDogs { result in
            switch result {
            case .success(let allDogs):
                self.dogsArray = allDogs
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            self.hideActivityIndicatory()
        }
        showActivityIndicatory()
        apiClient.getRandomImage { result in
            switch result {
            case .success(let image):
                print(image)
                
            case .failure(let error):
                print(error)
            }
            self.hideActivityIndicatory()
        }
        
        showActivityIndicatory()
    }
    
    private func configActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
    }
    
    private func showActivityIndicatory() {
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicatory() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
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
            apiClient2.postTags(with:self.dogsImage[self.dogsArray[indexPath.section].breed]!){
                result in
                switch result{
                case .success(let dogs):
                    print(dogs)
                    var ok = false
                    for item in dogs{
                        if item == self.dogsArray[indexPath.section].breed{
                            print ("Rasa ",self.dogsArray[indexPath.section].breed ,"exista!")
                            ok = true
                            break
                        }
                    }
                    if(ok == false){
                        print ("Rasa ",self.dogsArray[indexPath.section].breed ," NU exista!")
                    }
                case .failure(let error):
                    print (error)
                }
            }
            
        }
        else {
            print ( dogsArray[indexPath.section].subBreeds![indexPath.row] )
            performSegue(withIdentifier: "tranzitie", sender:  dogsArray[indexPath.section].subBreeds![indexPath.row] )
            apiClient2.postTags(with:self.dogsImage[ self.dogsArray[indexPath.section].subBreeds![indexPath.row]]!){
                result in
                switch result{
                case .success(let dogs):
                    print(dogs)
                    var ok = false
                    for item in dogs{
                        if item == self.dogsArray[indexPath.section].subBreeds![indexPath.row] {
                            print ("Subrasa ",self.dogsArray[indexPath.section].subBreeds![indexPath.row] ,"exista!")
                            ok = true
                            break
                        }
                    }
                    if(ok == false){
                        print ("Subrasa ",self.dogsArray[indexPath.section].subBreeds![indexPath.row] ," NU exista!")
                    }
                case .failure(let error):
                    print (error)
                }
            }
            
        }
        pozaIndex = String(indexPath.section%23)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let infoTableVC = segue.destination as!  DetailImageViewController
        infoTableVC.dogName = sender as? String
        print ("pozaIndex", pozaIndex)
        infoTableVC.imgNumber = pozaIndex
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dogsArray[indexPath.section].subBreeds?.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
            apiClient.getRandomImage(withBreed: String(dogsArray[indexPath.section].breed)) { result in
                switch result {
                case .success(let image):
                    let imageUrl = image.imageURL
                    if self.dogsImage[self.dogsArray[indexPath.section].breed] == nil {
                        do {
                            let data = try Data(contentsOf: URL(string: imageUrl)!)
                            DispatchQueue.main.sync {
                                self.imageView.image = UIImage(data: data)
                                cell.config(self.dogsArray[indexPath.section].breed,self.imageView.image!)
                                self.dogsImage [self.dogsArray[indexPath.section].breed] = self.imageView.image
                            }
                        }
                        catch let error {
                            print("error: \(error)")
                        }
                    }
                    else {
                        DispatchQueue.main.sync {
                    cell.config(self.dogsArray[indexPath.section].breed,self.dogsImage[self.dogsArray[indexPath.section].breed]!)
                            cell.separatorInset = UIEdgeInsets(top: 0, left: 89, bottom: 0, right:0)
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                }
                
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dogIdentifier", for: indexPath) as! TableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            
            apiClient.getRandomImage(withBreed: String(dogsArray[indexPath.section].breed), withSubbreed:dogsArray[indexPath.section].subBreeds![indexPath.row] ) { result in
                switch result {
                case .success(let image):
                    let imageUrl = image.imageURL
                    if self.dogsImage[ self.dogsArray[indexPath.section].subBreeds![indexPath.row]] == nil {
                        do {
                            let data = try Data(contentsOf: URL(string: imageUrl)!)
                            DispatchQueue.main.sync {
                                self.imageView.image = UIImage(data: data)
                                cell.config(self.dogsArray[indexPath.section].subBreeds![indexPath.row],self.imageView.image!)
                                self.dogsImage [self.dogsArray[indexPath.section].subBreeds![indexPath.row]] = self.imageView.image
                            }
                        }
                        catch let error {
                            print("error: \(error)")
                        }
                    }
                    else {
                        DispatchQueue.main.sync {
                            cell.config(self.dogsArray[indexPath.section].subBreeds![indexPath.row],self.dogsImage[ self.dogsArray[indexPath.section].subBreeds![indexPath.row]]!)
                            cell.separatorInset = UIEdgeInsets(top: 0, left: 89, bottom: 0, right:0)
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                }
                
            }
            
            return cell
            
        }
    }
}
