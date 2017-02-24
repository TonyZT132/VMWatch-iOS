//
//  GoogleHistoryStorage.swift
//  vmwatch
//
//  Created by Yanrong Wang on 2017-02-24.
//  Copyright © 2017 ECE496. All rights reserved.
//

import Foundation
import CoreData

internal class GoogleHistoryStorage {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).getContext()
    
    public func storeGoogleHistory (privateKeyID: String, privateKey: String, clientID: String, clientEmail: String, projectID: String, instanceID: String) throws {
        let entity =  NSEntityDescription.entity(forEntityName: "History_Google", in: self.context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(privateKeyID, forKey: "private_key_id")
        transc.setValue(privateKey, forKey: "private_key")
        transc.setValue(clientID, forKey: "client_id")
        transc.setValue(clientEmail, forKey: "client_email")
        transc.setValue(projectID, forKey: "project_id")
        transc.setValue(instanceID, forKey: "instance_id")
        transc.setValue(Date(), forKey: "date")
        
        //save the object
        do {
            try context.save()
            NSLog("Save success")
        } catch let error as NSError {
            NSLog("Could not save \(error), \(error.userInfo)")
            throw VMWEC2CoreDataStorageError.DatabaseStoreError
        }
    }
    
    public func getGoogleHistory() throws -> NSMutableArray {
        let fetchRequest: NSFetchRequest<History_Google> = History_Google.fetchRequest()
        let resultArr = NSMutableArray()
        do {
            let searchResults = try self.context.fetch(fetchRequest)
            NSLog("Fetch success")
            for trans in searchResults as [NSManagedObject]{
                var dict = [String : Any]()
                dict["private_key_id"] = trans.value(forKey: "private_key_id") as! String
                dict["private_key"] = trans.value(forKey: "private_key") as! String
                dict["client_id"] = trans.value(forKey: "client_id") as! String
                dict["client_email"] = trans.value(forKey: "client_email") as! String
                dict["instance_id"] = trans.value(forKey: "instance_id") as! String
                dict["date"] = trans.value(forKey: "date") as! Date
                resultArr.add(dict)
            }
            return resultArr
        } catch let error as NSError {
            NSLog("Error with request: \(error)")
            throw GoogleCoreDataStorageError.DatabaseFetchError
        }
    }
    
    public func deleteHistoryRecord(privateKeyID: String, privateKey: String, clientID: String, clientEmail: String, projectID: String, instanceID: String) throws {
        let fetchRequest: NSFetchRequest<History_Google> = History_Google.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false;
        
        let resultPredicate1 = NSPredicate(format: "private_key_id = %@", privateKeyID)
        let resultPredicate2 = NSPredicate(format: "private_key = %@", privateKey)
        let resultPredicate3 = NSPredicate(format: "client_id = %@", clientID)
        let resultPredicate4 = NSPredicate(format: "client_email = %@", clientEmail)
        let resultPredicate5 = NSPredicate(format: "project_id = %@", projectID)
        let resultPredicate6 = NSPredicate(format: "instance_id = %@", instanceID)
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [resultPredicate1, resultPredicate2, resultPredicate3, resultPredicate4,resultPredicate5,resultPredicate6])
        fetchRequest.predicate = compound
        do {
            let searchResults = try self.context.fetch(fetchRequest)
            
            if(searchResults.count > 0){
                for managedObject in searchResults
                {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    self.context.delete(managedObjectData)
                }
                NSLog("Delete record success")
            }
        } catch let error as NSError {
            NSLog("Error with request: \(error)")
            throw GoogleCoreDataStorageError.DatabaseDeleteError
        }
    }
    
    public func clearHistory() throws {
        let fetchRequest: NSFetchRequest<History_Google> = History_Google.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try self.context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                self.context.delete(managedObjectData)
            }
            NSLog("Database clear success")
        } catch let error as NSError {
            NSLog("Error : \(error) \(error.userInfo)")
            throw GoogleCoreDataStorageError.DatabaseDeleteError
        }
    }
}

enum GoogleCoreDataStorageError: Error {
    case DatabaseStoreError
    case DatabaseFetchError
    case DatabaseDeleteError
}
