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
            print("Save success")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            throw VMWEC2CoreDataStorageError.DatabaseStoreError
        }
    }
    
    public func getEC2History () throws -> [History_EC2] {
        let fetchRequest: NSFetchRequest<History_EC2> = History_EC2.fetchRequest()
        
        do {
            let searchResults = try self.context.fetch(fetchRequest)
            print ("num of results = \(searchResults.count)")
            
            for trans in searchResults as [NSManagedObject] {
                print("\(trans.value(forKey: "access_id"))")
            }
            return searchResults
        } catch {
            print("Error with request: \(error)")
            throw VMWEC2CoreDataStorageError.DatabaseFetchError
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


