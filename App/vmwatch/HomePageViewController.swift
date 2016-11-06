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
                    print("\(trans.value(forKey: "access_id"))")
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
