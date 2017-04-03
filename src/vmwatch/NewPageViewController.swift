
//
//  NewPageViewController.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-08.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class NewPageViewController: UIViewController {
    
    let alert = VMWAlertView()
    private var historydata:NSMutableArray!
    
    let WIDTH = UIScreen.main.bounds.width
    let HEIGHT = UIScreen.main.bounds.height
    let LOGO_SIZE_FACTOR:CGFloat = 1.70454545454545
    var SELECTION_BUTTON_HEIGHT:CGFloat!
    var scrollView: UIScrollView!
    
    var scrollViewHeight:CGFloat = 0
    var buttonArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadPage(){
        indicator.showWithMessage(context: "Requsting")
        PFCloud.callFunction(inBackground: "serviceRequest", withParameters: [:]) { (response, error) in
            indicator.dismiss()
            if(error == nil){
                do{
                    let jsonParser = VMWServiceJSONParser(inputData: response)
                    SERVICE =  try jsonParser.parse()
                    self.set_view()
                }catch {
                    self.present(
                        self.alert.showAlertWithOneButton(
                            title: "Failed",
                            message: "Could not get service",
                            actionButton: "OK"
                        ),
                        animated: true,
                        completion: nil
                    )
                }
            }else{
                self.present(
                    self.alert.showAlertWithOneButton(
                        title: "Failed",
                        message: "Could not get service",
                        actionButton: "OK"
                    ),
                    animated: true,
                    completion: nil
                )
            }
        }
    }
    
    private func set_view(){
        //set background
        let imageView   = UIImageView(frame: self.view.bounds);
        imageView.image = UIImage(named: "background")!
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        let top_y:CGFloat = self.navigationController!.navigationBar.frame.maxY;
        let bottom_y:CGFloat = self.tabBarController!.tabBar.frame.minY;
        let x = view.bounds.width * 0.05
        let width = view.bounds.width * 0.9
        //add title to the view
        let title = UILabel(frame: CGRect(x: x, y: top_y + 10, width: width, height: 20) )
        title.text = " Supported Service Providers"
        title.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        title.font = title.font.withSize(12)
        title.textColor = .white
        view.addSubview(title)
        //add button for each service provider
        let height: CGFloat = (bottom_y - top_y)/5
        var but_y :CGFloat = title.frame.maxY + 5
        for i in 0 ..< SERVICE.count {
            let selectionButton = UIButton(frame: CGRect(x: x, y: but_y, width: width, height: height))
            selectionButton.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
            let dict = SERVICE[i] as NSDictionary
            selectionButton.tag = i
            selectionButton.addTarget(self, action: #selector(self.buttonSelected(sender:)), for: .touchUpInside)
            selectionButton.clipsToBounds = true
            let logo = UIImage(named: dict["icon"] as! String)
            let logoView = UIImageView(frame: CGRect(x: 20, y: 10, width: width - 40, height: height - 20))
            logoView.image = logo
            logoView.contentMode = UIViewContentMode.scaleAspectFit
            selectionButton.addSubview(logoView)
            view.addSubview(selectionButton)
            buttonArr.add(selectionButton)
            but_y = selectionButton.frame.maxY + 5
        }
        
    }
    
    @objc private func buttonSelected (sender: UIButton!) {
        let dict = SERVICE[sender.tag] as NSDictionary
        let avaliability = dict["avaliable"] as! Bool
        if(avaliability == true){
            switch sender.tag {
            case 0:
                let ec2Setup : NewEC2WatchViewController = EC2View.instantiateViewController(withIdentifier: "ec2setup") as! NewEC2WatchViewController
                ec2Setup.hidesBottomBarWhenPushed = true
                self.navigationController!.navigationBar.tintColor = UIColor.white
                self.navigationController?.pushViewController(ec2Setup, animated: true)
            case 1:
                let GoogleSetup : GoogleInputViewController = GoogleView.instantiateViewController(withIdentifier: "GoogleSetup") as! GoogleInputViewController
                GoogleSetup.hidesBottomBarWhenPushed = true
                self.navigationController!.navigationBar.tintColor = UIColor.white
                self.navigationController?.pushViewController(GoogleSetup, animated: true)                
            default:
                self.present(
                    self.alert.showAlertWithOneButton(
                        title: "Error",
                        message: "Unknown Serivce",
                        actionButton: "OK"
                    ),
                    animated: true,
                    completion: nil
                )
            }
        }else{
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
                for trans in historydata{
                    let accessID = (trans as AnyObject).value(forKey: "access_id") as! String
                    let accessKey = (trans as AnyObject).value(forKey: "access_key") as! String
                    let instanceID = (trans as AnyObject).value(forKey: "instance_id") as! String
                    let region = (trans as AnyObject).value(forKey: "region") as! String
                    let date = (trans as AnyObject).value(forKey: "date") as! Date
                    
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
