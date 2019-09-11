
import UIKit
import CoreData

class DogsNewViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet var tableView: UITableView!
    var activityIndicator = UIActivityIndicatorView()
    let apiClient2 = DogAPI2Client.sharedInstance
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchRC: NSFetchedResultsController<Breeds>!
    private var query = ""
    let apiClient = DogAPIClient.sharedInstance
    var viewModel : DogsViewCoontrllerModel!
    var breedList = [BreedModel]()
    var subbreedList = [SubbreedModel]()
    var dogsArray = [Doggye]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configActivityIndicator()
        tableView.register(UINib(nibName: "CustomCellForSubbreed", bundle: Bundle.main), forCellReuseIdentifier: "dogIdentifier")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = true
        testNetworkCalls()
    }
    public func testNetworkCalls() {
        showActivityIndicatory()
        apiClient.getAllDogs { result in
            switch result {
            case .success( _):
                let request = Breeds.fetchRequest() as NSFetchRequest<Breeds>
                let breeds = try? self.context.fetch(request)
                let requestSubbreeds = Subbreeds.fetchRequest() as NSFetchRequest<Subbreeds>
                let subbreeds = try? self.context.fetch(requestSubbreeds)
                DispatchQueue.main.async {
                    for breed in breeds! {
                        if breed.has!.count > 0 {
                            var list : [SubbreedModel] = []
                            for subbreed in subbreeds! {
                                if subbreed.owner!.value(forKey: "name") as! String == breed.name! {
                                    DispatchQueue.main.async {
                                     //   let group = DispatchGroup()
                                        // group.enter()
                                        self.viewModel.imgDelegate!.getImage(withBreed: breed.name!, withSubreed: subbreed.name!, completion :{
                                            (result) in
                                            //                                            group.leave()
                                            //                                            list.append(SubbreedModel(image: result as Data, name: subbreed.name!))
                                        })
                                        //                                        group.notify(queue: .main, work: DispatchWorkItem(block: {
                                        //                                            // group.wait()
                                        //                                            self.hideActivityIndicatory()
                                        //                                            self.breedList.append(BreedModel(breedName: breed.name!, breedImage: Data(), subbreedList: list))
                                        //
                                        //                                            self.tableView.reloadData()
                                        //                                            self.tableView.delegate = self
                                        //                                            self.tableView.dataSource = self
                                        //                                            try? self.context.save()
                                        //                                            //  print("breedlist", self.breedList)
                                        //                                        }))
                                    }
                                    list.append(SubbreedModel(image: Data(),name: subbreed.name!))
                                }
                                
                            }
                            self.breedList.append(BreedModel(breedName: breed.name!, breedImage: Data(), subbreedList: list))
                        } else {
                            DispatchQueue.main.async {
                                let group = DispatchGroup()
                                group.enter()
                                self.viewModel.imgDelegate!.getImage(withBreed: breed.name!, completion: { (result) in
                                    
                                })
                                group.leave()
                                group.notify(queue: .main, work: DispatchWorkItem(block: {
                                    self.viewModel = DogsViewCoontrllerModel(withBreeds: self.breedList)
                                    self.tableView.reloadData()
                                    self.tableView.delegate = self
                                    self.tableView.dataSource = self
                                    try? self.context.save()
                                }))
                                
                            }
                            self.breedList.append(BreedModel(breedName: breed.name!, breedImage: Data(), subbreedList: []))
                        }
                        try? self.context.save()
                    }
                    self.viewModel = DogsViewCoontrllerModel(withBreeds: self.breedList)
                    self.tableView.reloadData()
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                }
                
            case .failure(let error):
                print(error)
            }
            self.hideActivityIndicatory()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel == nil ? 0 : viewModel.numberOfBreeds()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSubreedsInBreeds(atIndex: section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myBreed = viewModel.breed(atIndex: indexPath.section)
        let cell = tableView.dequeueReusableCell(withIdentifier: "dogIdentifier", for: indexPath) as! CustomCellForSubbreed
        tableView.reloadRows(at: [indexPath], with: .fade)
        let requestSubbreeds = Subbreeds.fetchRequest() as NSFetchRequest<Subbreeds>
        let subbreeds = try? self.context.fetch(requestSubbreeds)
        var img = Data()
        for subreed in subbreeds!{
            if subreed.name == myBreed.subbreedList[indexPath.row].name
            {
                if subreed.image != nil{
                    img = subreed.image! as Data
                    break
                }

            }
        }
//        let subreed = viewModel.breed(atIndex: indexPath.section).subbreedList[indexPath.row].name
//        viewModel.imgDelegate!.getImage(withBreed: myBreed.breedName, withSubreed:subreed, completion :{
//            (result) in
//            let cellViewModel = self.viewModel.customCellFirSubreedModel(withBreedIndex: indexPath.section, withSubreedIndex:indexPath.row, withImage: result as Data )
//            cell.viewModel = cellViewModel
//
//        })
        let cellViewModel = self.viewModel.customCellFirSubreedModel(withBreedIndex: indexPath.section, withSubreedIndex:indexPath.row, withImage: img )
         cell.viewModel = cellViewModel
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let infoTableVC = segue.destination as!  DetailImageViewController
        infoTableVC.dogName = sender as? String
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.breed(atIndex: section).subbreedList.count == 0 {
            return 86
        } else
        {
            return 16
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        
        let footerLine = UIView(frame: CGRect(x: 89, y: 0, width: tableView.frame.size.width, height:1 ))
        
        // footerLine.backgroundColor = .red
        
        footer.addSubview(footerLine)
        
        return footer
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  sectionHeader = UIView()
        var  titleLabel =  UILabel(frame: sectionHeader.bounds)
        titleLabel.frame = CGRect(x: 89, y: 0, width: tableView.frame.size.width-20, height: 16)
        let request = Breeds.fetchRequest() as NSFetchRequest<Breeds>
        let breeds = try? self.context.fetch(request)
        if viewModel.breed(atIndex: section).subbreedList.count == 0 {
            titleLabel = UILabel(frame: sectionHeader.bounds)
            titleLabel.text = viewModel.breed(atIndex: section).breedName.uppercased()
            titleLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
            titleLabel.frame = CGRect(x: 89, y: 0, width: tableView.frame.size.width, height: 50)
            let imageView = UIImageView(frame: CGRect(x: 35, y: 0, width: 40, height: 40));
//            let img = viewModel.breed(atIndex: section).breedImage
//            let image = UIImage(data: img)
            var img = Data()
            for breed in breeds!{
                if breed.name == viewModel.breed(atIndex: section).breedName{
                    img = breed.image as! Data
                    break
                }
            }
            imageView.image = UIImage(data: img)
            sectionHeader.addSubview(imageView)
            sectionHeader.addSubview(titleLabel)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sectionTapped(sender:)))
            tableView.addGestureRecognizer(tapGesture)
            tapGesture.delegate = self as? UIGestureRecognizerDelegate
        }
        else {
            titleLabel.text = viewModel.breed(atIndex: section).breedName.uppercased()
            titleLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
            sectionHeader.addSubview(titleLabel)
        }
        return sectionHeader
    }
    @objc func sectionTapped(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            guard let tableView = self.tableView else {
                return
            }
            if sender.view != nil {
                let tapLocation = sender.location(in: tableView)
                if let tapIndexPath = tableView.indexPathForRow(at: tapLocation) {
                    if (tableView.cellForRow(at: tapIndexPath)) != nil {
                        performSegue(withIdentifier: "transition", sender: viewModel.customCellFirSubreedModel(withBreedIndex: tapIndexPath.section, withSubreedIndex: tapIndexPath.row, withImage: Data()).nameDog)
                    }
                }  else {
                    for i in 0..<tableView.numberOfSections {
                        let sectionHeaderArea = tableView.rectForHeader(inSection: i)
                        if sectionHeaderArea.contains(tapLocation) {
                            print("You pressed:", viewModel.breed(atIndex: i).breedName)
                            print(viewModel.breed(atIndex: i).breedImage)
                            performSegue(withIdentifier: "transition", sender: viewModel.breed(atIndex: i).breedName )
                        }
                    }
                }
            }
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
    
    
}
