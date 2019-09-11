//
//  ViewControllerCollectionsModel.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 06/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class ViewControllerCollectionsModel{
    private let dogs: [DogDataModel]
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchRC: NSFetchedResultsController<Dog>!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var query = ""
    var dogFR : Dog!
    init( withDogs dogs:[DogDataModel]){
        self.dogs = dogs
    }
    func numberOfDogsInSection ()->Int{
        return dogs.count
    }
    
    func addDogs(){
        let request = Dog.fetchRequest() as NSFetchRequest<Dog>
        let dogList = try?self.context.fetch(request)
        for dog in dogs {
            if dogList?.isEmpty == true{
                dogFR = Dog(entity: Dog.entity(), insertInto: context)
                dogFR.image = dog.image.pngData() as NSData?
                dogFR.name = dog.name
            }
            
        }
        
        appDelegate.saveContext()
        refresh()
    }
    private func refresh()
    {
        let request = Dog.fetchRequest() as NSFetchRequest<Dog>
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        }
        let sort = NSSortDescriptor(key: #keyPath(Dog.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        do {
            fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
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
    func heightForPhoto(atIndex index: Int) -> CGFloat{
        return dogs[index].image.size.height
    }
    
}
