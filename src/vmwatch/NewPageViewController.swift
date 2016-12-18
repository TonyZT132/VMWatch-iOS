//
//  NewPageViewController.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-08.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit
import CoreData

class NewPageViewController: UIViewController {
    
    let alert = VMWAlertView()
    private var historydata:[History_EC2]! = []
    
    let WIDTH = UIScreen.main.bounds.width
    let HEIGHT = UIScreen.main.bounds.height
    let LOGO_SIZE_FACTOR:CGFloat = 1.70454545454545
    var SELECTION_BUTTON_HEIGHT:CGFloat!
    var scrollView: UIScrollView!
    
    var scrollViewHeight:CGFloat = 0
    var buttonArr = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeScrollView()
        self.loadSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initializeScrollView(){
        SELECTION_BUTTON_HEIGHT = WIDTH / LOGO_SIZE_FACTOR
        scrollView = UIScrollView(frame: CGRect(x:0, y:0, width: WIDTH, height: HEIGHT))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.backgroundColor = UIColor.clear.cgColor
        self.view.addSubview(scrollView)
    }
    
    private func loadSubView(){
        for i in 0 ... (SERVICE.count - 1) {
            let selectionButton = UIButton(frame: CGRect(x:0, y:scrollViewHeight, width: WIDTH, height: SELECTION_BUTTON_HEIGHT))
            selectionButton.tag = i
            selectionButton.addTarget(self, action: #selector(self.buttonSelected(sender:)), for: .touchUpInside)
            selectionButton.clipsToBounds = true
            let dict = SERVICE[i] as Dictionary
            let logo = UIImage(named: dict["icon"] as! String)
            let logoView = UIImageView(frame: CGRect(x:0, y:0, width: selectionButton.layer.frame.width, height: selectionButton.layer.frame.height))
            logoView.image = logo
            selectionButton.addSubview(logoView)
            scrollView.addSubview(selectionButton)
            buttonArr.add(selectionButton)
            scrollViewHeight += SELECTION_BUTTON_HEIGHT
        }
        scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)
    }
    
    @objc private func buttonSelected (sender: UIButton!) {
        switch sender.tag {
            case 0:
                let ec2Setup : NewEC2WatchTableViewController = EC2View.instantiateViewController(withIdentifier: "ec2setup") as! NewEC2WatchTableViewController
                ec2Setup.hidesBottomBarWhenPushed = true
                self.navigationController!.navigationBar.tintColor = UIColor.white
                self.navigationController?.pushViewController(ec2Setup, animated: true)
            
            default:
                self.present(
                    self.alert.showAlertWithOneButton(
                        title: "Opps",
                        message: "This service is not avaliable yet",
                        actionButton: "OK"
                    ),
                    animated: true,
                    completion: nil
                )
        }
    }
    
    func printHistoryData(){
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
}
