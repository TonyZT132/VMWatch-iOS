//
//  HomePageViewController.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-08.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit
import CoreData

class HomePageViewController: UIViewController {
    private var historydata:[History_EC2]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let history = VMWEC2HistoryStorage()
        do{
            self.historydata = try history.getEC2History()
            
            if(historydata.count > 0){
                for trans in historydata as [NSManagedObject] {
                    let accessID = trans.value(forKey: "access_id") as! String
                    let accessKey = trans.value(forKey: "access_key") as! String
                    let instanceID = trans.value(forKey: "instance_id") as! String
                    let region = trans.value(forKey: "region") as! String
                    let date = trans.value(forKey: "date") as! Date
                    
                    let accessIDLast4 = accessID.substring(from:accessID.index(accessID.endIndex, offsetBy: -4))
                    let accessKeyLast4 = accessKey.substring(from:accessKey.index(accessKey.endIndex, offsetBy: -4))
                    let instanceIDLast4 = instanceID.substring(from:instanceID.index(instanceID.endIndex, offsetBy: -4))
                    print("******\(accessIDLast4)")
                    print("**************\(accessKeyLast4)")
                    print("i-******\(instanceIDLast4)")
                    print(region)
                    print(date)
                }
            } else {
                NSLog("No history data found in the database")
            }
        } catch{
            NSLog("Could not get history data due to database issue")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
