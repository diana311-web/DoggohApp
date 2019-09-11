//
//  DogsViewController.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit
import CoreData

class DogsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchRC: NSFetchedResultsController<Breeds>!
    private var query = ""
    let apiClient2 = DogAPI2Client.sharedInstance
    private var sectionTitles = [String]()
    var dogs : [String:[String]] = [:]
    var dogsImage = [String : UIImage]()
    var images = [UIImage]()
    var pozaIndex = String("0")
    var activityIndicator = UIActivityIndicatorView()
    let apiClient = DogAPIClient.sharedInstance
    var viewModel : DogsViewCoontrllerModel!
    var breedList = [BreedModel]()
    var subbreedList = [SubbreedModel]()
    override func viewDidLoad() {
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: "CustomCellForSubbreed", bundle: Bundle.main), forCellReuseIdentifier: "dogIdentifier")
        tableView.register(UINib(nibName: "CustomCellForBreed", bundle: Bundle.main), forCellReuseIdentifier: "CustomTableViewCell")
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = true
        configActivityIndicator()
        testNetworkCalls()
     //   deleteAllData(entity: "Breeds")
        //deleteAllData(entity: "Subbreeds")
    }
    var data = Data()
    var imageView = UIImageView()
    public func testNetworkCalls() {
        showActivityIndicatory()
        apiClient.getAllDogs { result in
            switch result {
            case .success( _):
                print ("succes")
                self.refresh()
                let request = Breeds.fetchRequest() as NSFetchRequest<Breeds>
                let breeds = try? self.context.fetch(request)
                let requestSubbreeds = Subbreeds.fetchRequest() as NSFetchRequest<Subbreeds>
                let subbreeds = try? self.context.fetch(requestSubbreeds)
                DispatchQueue.main.async {
                   let group = DispatchGroup()
                    
                    group.notify(queue: .main, work: DispatchWorkItem(block: {
                         group.wait()
                        self.viewModel = DogsViewCoontrllerModel(withBreeds: self.breedList)
                        self.tableView.reloadData()
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        try? self.context.save()
                      //  print("breedlist", self.breedList)
                    }))
                    for breed in breeds! {
                        group.enter()
                        self.Subreeds(breed: breed, subbreeds: subbreeds!, completion: { (result) in
                        group.leave()
                        self.breedList.append(result)
                      //  print("breedlist",self.breedList)
                        })
                     }
                    }

                
            case .failure(let error):
                print(error)
            }
            self.hideActivityIndicatory()
        }
        
    }
    
    func Subreeds ( breed : Breeds, subbreeds: [Subbreeds], completion: ((BreedModel) -> ())?) {
        if breed.has!.count > 0 {
            var list : [SubbreedModel] = []
            for subbreed in subbreeds {
                if subbreed.owner!.value(forKey:"name") as! String == breed.name! {
                    self.apiClient.getRandomImage(withBreed: breed.name!,withSubbreed: subbreed.name!, completion: { (result) in
                        switch result{
                        case .success(let img):
                            let image = img.imageURL
                            let data = image.data(using: .utf8)
                            subbreed.image = data as NSData?
                            list.append(SubbreedModel( image: subbreed.image! as Data, name: subbreed.name!))
                        case .failure(let error):
                            print(error)
                        }
                    })
                 
                }
            }
            completion?(BreedModel(breedName: breed.name!, breedImage: Data(), subbreedList: list))
        } else {

            var list2 : [SubbreedModel] = []
            self.apiClient.getRandomImage(withBreed: breed.name!, completion: { (result) in
                switch result{
                case .success(let img):
                    let image = img.imageURL
                    let data = image.data(using: .utf8)
                    breed.image = data as NSData?
                    list2.append(SubbreedModel( image: Data() , name: "zeroSubreeds"))
                    completion?(BreedModel(breedName: breed.name!, breedImage: breed.image! as Data, subbreedList: list2))
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
       do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
        
    }
    private func refresh()
    {
        let request = Breeds.fetchRequest() as NSFetchRequest<Breeds>
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        }
        let sort = NSSortDescriptor(key: #keyPath(Dog.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        do {
            fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchRC.performFetch()
            print ("fetch", self.fetchRC.fetchedObjects?.count ?? 0)
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
        return viewModel.numberOfBreeds()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("subbreed",viewModel.customCellForBreedModel(atIndex: section).breedName,viewModel.numberOfSubreedsInBreeds(atIndex: section))
        return viewModel.numberOfSubreedsInBreeds(atIndex: section)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let  sectionHeader = UIView()
        let titleLabel =  UILabel(frame: sectionHeader.bounds)
        sectionHeader.addSubview(titleLabel)
       
        if viewModel.firstSubbreedInBreed(atIndex: section) == "zeroSubreeds" {
            return UIView(frame: CGRect.zero)
        }
        else
        {
            titleLabel.font = UIFont(name: "Montserrat-Bold", size: 14)
            titleLabel.textAlignment = .left
            titleLabel.frame = CGRect(x: 89, y: 0, width: tableView.frame.size.width-20, height: 20)
            titleLabel.text = viewModel.customCellForBreedModel(atIndex: section).breedName.uppercased()
            return sectionHeader
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.numberOfSubreedsInBreeds(atIndex: section) == 0{
            let footer = UIView()
            let footerView = UIView(frame: CGRect(x: 89, y: 0, width:  tableView.frame.size.width, height: 2))
            footerView.backgroundColor = #colorLiteral(red: 0.9426903725, green: 0.9571765065, blue: 0.9741945863, alpha: 1)
            footer.addSubview(footerView)
            return footer
        }
        return UIView(frame: CGRect.zero)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breed = viewModel.breed(atIndex: indexPath.section)
        let subbreed = breed.subbreedList
        if breed.subbreedList[indexPath.row].name == "zeroSubreeds"{
            performSegue(withIdentifier: "transition", sender: breed.breedName)
            apiClient2.postTags(with:self.dogsImage[breed.breedName]!){
                result in
                switch result{
                case .success(let dogs):
                    print(dogs)
                    var ok = false
                    for item in dogs{
                        if item == breed.breedName{
                            print ("Breed ",breed.breedName.uppercased() ,"exist!")
                            ok = true
                            break
                        }
                    }
                    if(ok == false){
                        print ("Breed ",breed.breedName.uppercased()," doesn't exist!")
                    }
                case .failure(let error):
                    print (error)
                }
            }
            
        }
        else {
            performSegue(withIdentifier: "transition", sender: subbreed[indexPath.row].name)
            apiClient2.postTags(with: self.dogsImage[subbreed[indexPath.row].name]!){
                result in
                switch result{
                case .success(let dogs):
                    print(dogs)
                    var ok = false
                    for item in dogs{
                        if item == subbreed[indexPath.row].name{
                            print ("Subbreed ",subbreed[indexPath.row].name,"exist!")
                            ok = true
                            break
                        }
                    }
                    if(ok == false){
                        print ("Subbreed ",subbreed[indexPath.row].name ,"doesn;t exist!")
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
        let breed = viewModel.breed(atIndex: indexPath.section)
        if breed.subbreedList[indexPath.row].name == "zeroSubreeds"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomCellForBreed
            var cellViewModel = viewModel.customCellForBreedModel(atIndex: indexPath.section)
            cell.viewModel = cellViewModel
        
//            apiClient.getRandomImage(withBreed: viewModel.customCellForBreedModel(atIndex: indexPath.section))
//            { result in
//                switch result {
//                case .success(let image):
//                    let imageUrl = image.imageURL
//                    if self.dogsImage[self.viewModel.customCellForBreedModel(atIndex:indexPath.section).breedName] == nil{
//                        do {
//                            let data = try Data(contentsOf: URL(string: imageUrl)!)
//                            DispatchQueue.main.sync {
//                                self.imageView.image = UIImage(data: data)
//                                cell.config(self.viewModel.customCellForBreedModel(atIndex:indexPath.section).breedName,self.imageView.image!)
//                                self.dogsImage[self.viewModel.customCellForBreedModel(atIndex:indexPath.section).breedName] = self.imageView.image
//
//                            }
//                        }
//                        catch let error {
//                            print("error: \(error)")
//                        }
//                    }
//                    else {
//                        DispatchQueue.main.sync {
//                            cell.config(self.viewModel.customCellForBreedModel(atIndex:indexPath.section).breedName,self.dogsImage[self.viewModel.customCellForBreedModel(atIndex:indexPath.section).breedName]!)
//                            cell.separatorInset = UIEdgeInsets(top: 0, left: 89, bottom: 0, right:0)
//                        }
//                        
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//                
//            }
//            cell.config(self.viewModel.customCellForBreedModel(atIndex: indexPath.section).breedName, UIImage(data:self.viewModel.breed(atIndex: indexPath.section).breedImage)!)
            return cell
        }
        else
        {
            let myBreed = viewModel.breed(atIndex: indexPath.section)
            let mySubbreed = myBreed.subbreedList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dogIdentifier", for: indexPath) as! CustomCellForSubbreed
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            apiClient.getRandomImage(withBreed : myBreed,
                                     withSubbreed : mySubbreed)
            { result in
                switch result {
                case .success(let image):
                    let imageUrl = image.imageURL
                    if self.dogsImage[mySubbreed.name] == nil{
                        do {
                            let data = try Data(contentsOf: URL(string: imageUrl)!)
                            DispatchQueue.main.sync {
                                self.imageView.image = UIImage(data: data)
                                cell.config(mySubbreed.name,self.imageView.image!)
                                self.dogsImage [mySubbreed.name] = self.imageView.image
                            }
                        }
                        catch let error {
                            print("error: \(error)")
                        }
                    }
                    else {
                        DispatchQueue.main.sync {
                            cell.config(mySubbreed.name, self.dogsImage[mySubbreed.name]!)
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
