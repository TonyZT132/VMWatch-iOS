//
//  VMWCoreDataStorage.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2016-11-06.
//  Copyright © 2016 ECE496. All rights reserved.
//

import Foundation
import CoreData


internal class VMWHistoryStorage {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).getContext()
    
    public func storeEC2History (accessID: String, accessKey: String) {
        let entity =  NSEntityDescription.entity(forEntityName: "History", in: self.context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(accessID, forKey: "access_id")
        transc.setValue(accessKey, forKey: "access_key")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func getEC2History () {
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        
        do {
            let searchResults = try self.context.fetch(fetchRequest)
            print ("num of results = \(searchResults.count)")
            
            for trans in searchResults as [NSManagedObject] {
                print("\(trans.value(forKey: "access_id"))")
            }
        } catch {
            print("Error with request: \(error)")
        }
    }
}
