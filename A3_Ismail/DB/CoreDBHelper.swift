//
//  CoreDBHelper.swift
//  A3_Ismail
//
//  Created by Ismail Gok on 2022-05-26.
//

import UIKit
import CoreData

class CoreDBHelper {
    
    // MARK: - Properties
    
    private static var shared: CoreDBHelper?
    private let moc: NSManagedObjectContext
    private let ENTITY_NAME = "FavoriteCountry"
    
    // MARK: - Initializers
    
    static func getInstance() -> CoreDBHelper{
        
        if shared == nil{
            shared = CoreDBHelper(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        }
        
        return shared!
    }
    
    private init(context : NSManagedObjectContext){
        self.moc = context
    }
    
    // MARK: - DB Functions
    
    func insertFavorite(countryName: String) {
        
        do{
            let orderToBeInserted = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: self.moc) as! FavoriteCountry
            
            orderToBeInserted.countryName = countryName
            
            if self.moc.hasChanges{
                try self.moc.save()
                
                print(#function, "Data is saved successfully in CoreData")
            }
            
        }
        catch let error as NSError{
            print(#function, "Could not save the data \(error)")
        }
    }
    
    func getAllFavorites() -> [FavoriteCountry]? {
        let fetchRequest = NSFetchRequest<FavoriteCountry>(entityName: ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "countryName", ascending: true)] // fetch the favorite countries in ascending order by their name
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            print(#function, "Fetched Data : \(result as [FavoriteCountry])")
            
            return result as [FavoriteCountry]
            
        }catch let error as NSError{
            print(#function, "Could not fetch the data \(error)")
        }
        
        return nil
    }
    
    func searchFavorite(countryName: String) -> FavoriteCountry?{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        let predicateID = NSPredicate(format: "countryName == %@", countryName as CVarArg)
        fetchRequest.predicate = predicateID
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            
            if result.count > 0{
                print(#function, "Matching object found")
                return result.first as? FavoriteCountry
            }
            
        }catch let error as NSError{
            print(#function, "Unable to search for task \(error)")
        }
        
        return nil
    }
    
    func deleteFavorite(countryName: String) {
        let searchResult = self.searchFavorite(countryName: countryName)
        
        if (searchResult != nil){
            do{
                
                self.moc.delete(searchResult!)
                try self.moc.save()
                
                print(#function, "Favorite deleted successfully")
                
            }catch let error as NSError{
                print(#function, "Could not delete the favorite: \(error)")
            }
        }else{
            print(#function, "No matching record found")
        }
    }
    
    
}
