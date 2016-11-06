//
//  VMWCoreDataStorage.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2016-11-06.
//  Copyright © 2016 ECE496. All rights reserved.
//

import Foundation
import CoreData


internal class VMWEC2HistoryStorage {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).getContext()
    
    public func storeEC2History (accessID: String, accessKey: String, instanceID: String, region:String) throws {
        let entity =  NSEntityDescription.entity(forEntityName: "History_EC2", in: self.context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(accessID, forKey: "access_id")
        transc.setValue(accessKey, forKey: "access_key")
        transc.setValue(instanceID, forKey: "instance_id")
        transc.setValue(region, forKey: "region")
        transc.setValue(Date(), forKey: "date")
        
        //save the object
        do {
            try context.save()
            NSLog("Save success")
        } catch let error as NSError  {
            NSLog("Could not save \(error), \(error.userInfo)")
            throw VMWEC2CoreDataStorageError.DatabaseStoreError
        }
    }
    
    public func getEC2History() throws -> [History_EC2] {
        let fetchRequest: NSFetchRequest<History_EC2> = History_EC2.fetchRequest()
        
        do {
            let searchResults = try self.context.fetch(fetchRequest)
            return searchResults
        } catch {
            NSLog("Error with request: \(error)")
            throw VMWEC2CoreDataStorageError.DatabaseFetchError
        }
    }
    
    public func deleteHistoryRecord(accessID:String, accessKey:String, instanceID: String, region:String){
        let fetchRequest: NSFetchRequest<History_EC2> = History_EC2.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "accessID", ascending: true)]
        
        /*
         TODO: Finish NSPredicate
         */
    }
    
    public func clearHistory(entity: String){
        let fetchRequest: NSFetchRequest<History_EC2> = History_EC2.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try self.context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                self.context.delete(managedObjectData)
            }
        } catch let error as NSError {
            NSLog("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}

internal class VMWHistoryDate {
    private func getCurrentDate() -> Date {
        return Date()
    }
    
    public func getHistoryDateRange(date:Date){

    }
}

enum VMWEC2CoreDataStorageError: Error {
    case DatabaseStoreError
    case DatabaseFetchError
}


