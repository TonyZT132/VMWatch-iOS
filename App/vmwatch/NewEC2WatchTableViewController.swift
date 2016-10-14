//
//  NewEC2WatchTableViewController.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2016-10-13.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class NewEC2WatchTableViewController: UITableViewController, IQActionSheetPickerViewDelegate {
    
    let EC2_REGION = [
        "us-east-1"
    ]
    
    var region:String?
    
    @IBOutlet weak var ec2AccessIDTextField: UITextField!
    @IBOutlet weak var ec2AccessKeyTextField: UITextField!
    @IBOutlet weak var instanceIDTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var regionSelectionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
            case 0:
                return 2
            case 1:
                return 1
            case 2:
                return 1
            default:
                return 0
        }
    }
    
    @IBAction func selectRegion(_ sender: AnyObject) {
        /*Setup alert for photo selection type menu (take photo or choose existing photo)*/
        let optionMenu = UIAlertController(title: nil, message: "Please select region", preferredStyle: .actionSheet)
        
        /*Setup the photo picker*/
        let USEast = UIAlertAction(title: "US East (N. Virginia)", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.region = "us-east-1"
            self.regionSelectionButton.setTitle("us-east-1", for: .normal)
            return
        })
        
        let USWestOne = UIAlertAction(title: "US West (N. California)", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.region = "us-west-1"
            self.regionSelectionButton.setTitle("us-west-1", for: .normal)
            return
        })
        
        let USWestTwo = UIAlertAction(title: "US West (Oregon)", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.region = "us-west-2"
            self.regionSelectionButton.setTitle("us-west-2", for: .normal)
            return
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.region = nil
            self.regionSelectionButton.setTitle("Please select region", for: .normal)
            return
        })
        
        /*Add all actions*/
        optionMenu.addAction(USEast)
        optionMenu.addAction(USWestOne)
        optionMenu.addAction(USWestTwo)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func doSubmit(_ sender: AnyObject) {
        let params = [
            "accessid" as NSObject: ec2AccessIDTextField.text! as AnyObject,
            "accesskey" as NSObject: ec2AccessKeyTextField.text! as AnyObject,
            "instanceid" as NSObject: instanceIDTextField.text! as AnyObject,
            "region" as NSObject: "us-east-1" as AnyObject
            ] as [NSObject:AnyObject]
        
        PFCloud.callFunction(inBackground: "ec2Watch", withParameters: params) { (response, error) in
            print("call done");
        }
    }
}
