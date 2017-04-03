//
//  InstanceListViewController.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2017-04-01.
//  Copyright © 2017 ECE496. All rights reserved.
//

import UIKit

class InstanceListViewController: UIViewController {
    
    let alert = VMWAlertView()
    
    let WIDTH = UIScreen.main.bounds.width
    let HEIGHT = UIScreen.main.bounds.height
    var scrollView: UIScrollView!
    
    var scrollViewHeight:CGFloat = 0
    
    let SPACE:CGFloat! = 5
    let TITLE_VIEW_HEIGHT:CGFloat! = 20
    let VM_ITEM_VIEW_HEIGHT:CGFloat! = 70
    
    var VMList = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.setScrollView()
        let subViews = self.scrollView.subviews
        
        // delete all views in scrollview
        for subview in subViews {
            subview.removeFromSuperview()
        }
        
        // re-set the height of the scrollview
        
        scrollViewHeight = 0
        setVMListView()
        scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setScrollView(){
        let NavBarYPosition:CGFloat = self.navigationController!.navigationBar.frame.maxY;
        //let TabBarYPosition:CGFloat = self.tabBarController!.tabBar.frame.minY;
        
        scrollView = UIScrollView(frame: CGRect(x:0, y: NavBarYPosition, width: WIDTH, height: HEIGHT - NavBarYPosition))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.backgroundColor = UIColor.clear.cgColor
        self.view.addSubview(scrollView)
    }
    
    private func setVMListView(){
        if(VMList.count > 0){
            for i in 0 ... (VMList.count - 1){
                let dict = VMList[i] as! NSDictionary
                
                scrollViewHeight += SPACE
                let VMItem = UIView(frame: CGRect(x: 25, y: scrollViewHeight, width: WIDTH - 50, height: VM_ITEM_VIEW_HEIGHT))
                VMItem.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
                
                let ICON_VIEW_SIZE = 60
                let iconView = UIImageView(frame: CGRect(x: 5, y: 5, width: ICON_VIEW_SIZE, height: ICON_VIEW_SIZE))
                
                iconView.image = UIImage(named: returnIconImage(cate: (dict["cate"] as! String)))!
                iconView.layer.cornerRadius = iconView.frame.height / 2
                iconView.clipsToBounds = true
                VMItem.addSubview(iconView)
                
                let ARROW_VIEW_SIZE = 30
                let arrowView = UIView(frame: CGRect(x: Int(VMItem.frame.width - CGFloat(50)), y: 20, width: ARROW_VIEW_SIZE, height: ARROW_VIEW_SIZE))
                arrowView.backgroundColor = UIColor.clear
                arrowView.layer.cornerRadius = arrowView.frame.height / 2
                arrowView.clipsToBounds = true
                
                let arrowImage = UIImageView(frame: CGRect(x: 0, y: 0, width: arrowView.frame.width, height: arrowView.frame.height))
                
                arrowImage.image = UIImage(named: "arrow")!
                arrowImage.layer.cornerRadius = arrowImage.frame.height / 2
                arrowImage.clipsToBounds = true
                arrowView.addSubview(arrowImage)
                
                VMItem.addSubview(arrowView)
                
                let instanceIDView = UILabel(frame: CGRect(x: 5 + iconView.frame.width + 5, y: VMItem.frame.height / 2 - 7 , width: VMItem.frame.width - iconView.frame.width - arrowView.frame.width - 40, height: 20) )
                let instanceID = dict["instance_id"] as! String
                instanceIDView.text = " " + instanceID
                instanceIDView.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
                instanceIDView.font = instanceIDView.font.withSize(14)
                instanceIDView.textColor = .white
                VMItem.addSubview(instanceIDView)
                
                let VMButton = UIButton(frame: CGRect(x: 0, y: 0, width: VMItem.frame.width, height: VMItem.frame.height))
                let cloud = dict["cate"] as! String
                if(cloud == "google"){
                    // button in the home page to quick access the result page
                    do{
                        let resultArray = try GoogleHistoryStorage().getGoogleHistory()
                        for googleresult in resultArray.objectEnumerator().allObjects as! [[String:Any]]{
                            let insID = dict["instance_id"] as! String
                            let googlehistory_instanceID = googleresult["instance_id"] as! String
                            if(googlehistory_instanceID == insID){
                                VMButton.addTarget(self, action: #selector(pushGoogleResult), for: .touchUpInside)
                                VMButton.tag = resultArray.index(of: googleresult)
                                print("google: instanceID: \(googlehistory_instanceID) index \(resultArray.index(of: googleresult))")
                                VMItem.addSubview(VMButton)
                                scrollView.addSubview(VMItem)
                            }
                        }
                    } catch {
                        print("Google Fetch Result Error")
                    }
                }else if(cloud == "aws"){
                    VMButton.addTarget(self, action: #selector(pushAWSResult), for: .touchUpInside)
                    VMButton.tag = i
                    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
                    VMButton.addGestureRecognizer(longGesture)
                    longGesture.view?.tag = i
                    VMItem.addSubview(VMButton)
                    scrollView.addSubview(VMItem)
                }
                scrollViewHeight += VM_ITEM_VIEW_HEIGHT
            }
        }
    }
    
    private func returnIconImage(cate:String) -> String {
        switch cate {
        case "aws":
            return "aws_icon"
        case "google":
            return "google_icon"
        default:
            return "cloud_icon"
        }
    }
    
    @objc private func pushGoogleResult(sender: UIButton){
        do{
            let resultArray = try GoogleHistoryStorage().getGoogleHistory()
            let dict = resultArray[sender.tag] as! [String:Any]
            
            PFCloud.callFunction(inBackground: "GoogleWatch", withParameters: ["privatekeyid" :  dict["private_key_id"]!, "privatekey" : dict["private_key"]!, "clientid" : dict["client_id"]! , "clientemail" : dict["client_email"]!, "instanceid" : dict["instance_id"]!, "projectid" : dict["project_id"]!]){ (response, error) in
                if(error == nil){
                    let GoogleResult : GoogleWatchResultViewController = GoogleView.instantiateViewController(withIdentifier: "GoogleResult") as! GoogleWatchResultViewController
                    
                    GoogleResult.hidesBottomBarWhenPushed = true
                    self.navigationController!.navigationBar.tintColor = UIColor.white
                    self.navigationController?.pushViewController(GoogleResult, animated: true)
                    
                    GoogleResult.instanceID = dict["instance_id"] as? String
                    GoogleResult.response = response
                }
            }
        }catch{
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Connection Failed",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }
    }
    
    @objc private func pushAWSResult(sender: UIButton){
        let instance = VMList[sender.tag] as! NSDictionary
        let accessID = instance["access_id"] as! String
        let accessKey = instance["access_key"] as! String
        let instanceID = instance["instance_id"] as! String
        let region = instance["region"] as! String
        
        self.present(
            alert.showAlertWithTwoButton(
                title: "Message",
                message: "Do you want to connect to " + instanceID,
                actionButtonOne: "Yes",
                actionButtonTwo: "No",
                handlerOne: {() -> Void in
                    indicator.showWithMessage(context: "Verifying")
                    PFCloud.callFunction(inBackground: "ec2UserVerification", withParameters: ["accessid": accessID, "accesskey":accessKey]) { (response, error) in
                        
                        indicator.dismiss()
                        if(error == nil){
                            let ec2Result : EC2WatchResultViewController = EC2View.instantiateViewController(withIdentifier: "ec2result") as! EC2WatchResultViewController
                            
                            ec2Result.accessID = accessID
                            ec2Result.accessKey = accessKey
                            ec2Result.instanceID = instanceID
                            ec2Result.region = region
                            ec2Result.hidesBottomBarWhenPushed = true
                            self.navigationController!.navigationBar.tintColor = UIColor.white
                            self.navigationController?.pushViewController(ec2Result, animated: true)
                        }else{
                            print(error!)
                            self.present(
                                self.alert.showAlertWithOneButton(
                                    title: "Error",
                                    message: "Invalid Access Credentials",
                                    actionButton: "OK"
                                ),
                                animated: true,
                                completion: nil
                            )
                        }
                    }
            },
                handlerTwo: {() -> Void in
                    return
            }
            ),
            animated: true,
            completion: nil
        )
    }
    
    func longTap(sender : UIGestureRecognizer){
        let tag = (sender.view?.tag)! as Int
        
        let instance = VMList[tag] as! NSDictionary
        let accessID = instance["access_id"] as! String
        let accessKey = instance["access_key"] as! String
        let instanceID = instance["instance_id"] as! String
        let region = instance["region"] as! String
        
        /*Setup alert for photo selection type menu (take photo or choose existing photo)*/
        let optionMenu = UIAlertController(title: nil, message: "Please select", preferredStyle: .actionSheet)
        
        let USWestTwo = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            let dict = self.VMList[tag] as! NSDictionary
            let cate = dict["cate"] as! String
            
            if (cate == "aws"){
                self.deleteAccessCredential(accessID: accessID, accessKey: accessKey, instanceID: instanceID, region: region)
            }
            return
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
            return
        })
        
        optionMenu.addAction(USWestTwo)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func deleteAccessCredential(accessID:String, accessKey:String, instanceID:String, region:String){
        
        let storeParams = [
            "accessid" as NSObject: accessID as AnyObject,
            "accesskey" as NSObject: accessKey as AnyObject,
            "instanceid" as NSObject: instanceID as AnyObject,
            "region" as NSObject: region as AnyObject,
            "userid" as NSObject: PFUser.current()?.objectId! as AnyObject
        ] as [NSObject:AnyObject]
        
        do{
            try PFCloud.callFunction("deleteEC2CredentialRecord", withParameters: storeParams)
        }catch{
            print("Error")
        }
        
        reloadView()
    }
    
    func reloadView(){
        let storeParams = [
            "userid" as NSObject: PFUser.current()?.objectId! as AnyObject
            ] as [NSObject:AnyObject]
        
        PFCloud.callFunction(inBackground: "ec2UserDataGet", withParameters: storeParams) { (response, ec2StoreError) in
            if(ec2StoreError == nil){
                do{
                    let parser = VMWEC2CredentialJSONParser(inputData: response)
                    self.VMList = try parser.parse()
                    
                } catch {
                    self.VMList = []
                }
                
                let subViews = self.scrollView.subviews
                
                // delete all views in scrollview
                for subview in subViews {
                    subview.removeFromSuperview()
                }
                
                // re-set the height of the scrollview
                self.scrollViewHeight = 0
                self.setVMListView()
            }else{
                self.present(
                    self.alert.showAlertWithOneButton(
                        title: "Error",
                        message: "Fail to get stored credentials",
                        actionButton: "OK"
                    ),
                    animated: true,
                    completion: nil
                )
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
