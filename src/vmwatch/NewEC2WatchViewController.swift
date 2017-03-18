//
//  NewEC2WatchViewController.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2017-03-17.
//  Copyright © 2017 ECE496. All rights reserved.
//

import UIKit

class NewEC2WatchViewController: UIViewController {
    
    var region:String?
    
    var txtAccessID: UITextField!
    var txtAccessKey: UITextField!
    var txtInstanceID: UITextField!
    var pSwitch: UISwitch!
    
    let alert = VMWAlertView()
    
    var regionButton: UIButton!
    
    let WIDTH = UIScreen.main.bounds.width
    let HEIGHT = UIScreen.main.bounds.height
    var scrollView: UIScrollView!
    
    var scrollViewHeight:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.setScrollView()
        self.setLogoView()
        self.setInputList()
        self.setRegionSelection()
        self.setStorePreference()
        self.setSubmitButton()

        scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setScrollView(){
        let NavBarYPosition:CGFloat = self.navigationController!.navigationBar.frame.maxY;
        
        scrollView = UIScrollView(frame: CGRect(x:0, y: NavBarYPosition, width: WIDTH, height: HEIGHT - NavBarYPosition))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.backgroundColor = UIColor.clear.cgColor
        self.view.addSubview(scrollView)
    }
    
    private func setLogoView(){
        let logo = UIImage(named: "aws-logo")
        let logoView = UIImageView(frame: CGRect(x: view.bounds.width * 0.1, y: 30, width: view.bounds.width * 0.8, height: view.bounds.height * 0.2))
        logoView.image = logo
        logoView.contentMode = UIViewContentMode.scaleAspectFit
        scrollView.addSubview(logoView)
        scrollViewHeight += 30 + logoView.frame.height
    }
    
    private func setInputList(){
        txtAccessID = setInputTxtField(y: scrollViewHeight + 20,txt: "Access ID")
        scrollView.addSubview(txtAccessID)
        scrollViewHeight += 20 + txtAccessID.frame.height
        
        txtAccessKey = setInputTxtField(y: scrollViewHeight + 20,txt: "Access Key")
        scrollView.addSubview(txtAccessKey)
        scrollViewHeight += 20 + txtAccessKey.frame.height
        
        txtInstanceID = setInputTxtField(y: scrollViewHeight + 20,txt: "Instance ID")
        scrollView.addSubview(txtInstanceID)
        scrollViewHeight += 20 + txtInstanceID.frame.height
    }
    
    func setInputTxtField (y: CGFloat,txt: String) -> UITextField {
        let x: CGFloat = self.view.bounds.width * 0.05
        let width: CGFloat = self.view.bounds.width * 0.9
        
        let txtField = UITextField(frame: CGRect(x: x, y: y, width: width, height: 30))
        txtField.returnKeyType = .next
        txtField.textColor = UIColor.white
        txtField.attributedPlaceholder = NSAttributedString(string: txt, attributes: [NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        
        let border = CALayer()
        let widthBoarder = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: txtField.frame.size.height - widthBoarder, width:  txtField.frame.size.width, height: txtField.frame.size.height)
        
        border.borderWidth = widthBoarder
        txtField.layer.addSublayer(border)
        txtField.layer.masksToBounds = true
        
        return txtField
    }
    
    private func setRegionSelection(){
        let x: CGFloat = self.view.bounds.width * 0.05
        let width: CGFloat = self.view.bounds.width * 0.9
        
        regionButton = UIButton(frame: CGRect(x:x , y: scrollViewHeight + 25, width: width, height: 40))
        regionButton.setTitle("Please select region", for: .normal)
        regionButton.contentHorizontalAlignment = .center
        regionButton.layer.borderWidth = 1
        regionButton.layer.borderColor = UIColor.white.cgColor
        regionButton.layer.cornerRadius = 5
        regionButton.clipsToBounds = true
        regionButton.titleLabel?.font = regionButton.titleLabel?.font.withSize(16)
        regionButton.addTarget(self, action: #selector(self.selectRegion(sender:)), for: .touchUpInside)
        
        scrollViewHeight += 25 + regionButton.frame.height
        scrollView.addSubview(regionButton)
    }
    
    @objc private func selectRegion (sender: UIButton!) {
        /*Setup alert for photo selection type menu (take photo or choose existing photo)*/
        let optionMenu = UIAlertController(title: nil, message: "Please select region", preferredStyle: .actionSheet)
        
        /*Setup the photo picker*/
        let USEast = UIAlertAction(title: "US East (N. Virginia)", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.region = "us-east-1"
            self.regionButton.setTitle("us-east-1", for: .normal)
            return
        })
        
        let USWestOne = UIAlertAction(title: "US West (N. California)", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.region = "us-west-1"
            self.regionButton.setTitle("us-west-1", for: .normal)
            return
        })
        
        let USWestTwo = UIAlertAction(title: "US West (Oregon)", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.region = "us-west-2"
            self.regionButton.setTitle("us-west-2", for: .normal)
            return
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.region = nil
            self.regionButton.setTitle("Please select region", for: .normal)
            return
        })
        
        /*Add all actions*/
        optionMenu.addAction(USEast)
        optionMenu.addAction(USWestOne)
        optionMenu.addAction(USWestTwo)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func setStorePreference(){
        if(PFUser.current() != nil){
            let x: CGFloat = self.view.bounds.width * 0.05
            let width: CGFloat = self.view.bounds.width * 0.9
            let view = UIView(frame: CGRect(x:x , y: scrollViewHeight + 15, width: width, height: 45))
            
            pSwitch = UISwitch(frame: CGRect(x:view.frame.width - 50 , y: 5, width: 30, height: 10))
            view.addSubview(pSwitch)
            
            let label = UILabel(frame: CGRect(x:0 , y: 10, width: view.frame.width - 25 - pSwitch.frame.width, height: 25))
            label.font = label.font.withSize(16)
            label.text = "Store this VM"
            label.textColor = .white
            
            view.addSubview(label)
            
            scrollView.addSubview(view)
            scrollViewHeight += 15 + view.frame.height
        }
    }
    
    private func setSubmitButton(){
        let x: CGFloat = self.view.bounds.width * 0.05
        let width: CGFloat = self.view.bounds.width * 0.9
        
        let butSubmit = UIButton(frame: CGRect(x: x, y: scrollViewHeight + 60, width: width, height: 40))
        butSubmit.backgroundColor = UIColor(red: 1 / 255, green: 61 / 255, blue: 123 / 255, alpha: 0.8)
        butSubmit.setTitle("Submit", for: .normal)
        butSubmit.addTarget(self, action: #selector(self.submitTapped), for: .touchUpInside)
        butSubmit.layer.cornerRadius = butSubmit.frame.height * 0.5
        butSubmit.layer.borderWidth = 1
        butSubmit.layer.borderColor = UIColor.clear.cgColor
        scrollView.addSubview(butSubmit)
        scrollViewHeight += 60 + butSubmit.frame.height
    }
    
    @objc private func submitTapped (sender: UIButton!){
        do{
            let parser = VMWEC2InputParser()
            try parser.accessIDParser(input: txtAccessID.text)
            try parser.secretKeyParser(input: txtAccessKey.text)
            try parser.instanceIDParser(input: txtInstanceID.text)
            try parser.regionParser(input: self.region)
            
            indicator.showWithMessage(context: "Verifying")
            PFCloud.callFunction(inBackground: "ec2UserVerification", withParameters: ["accessid": txtAccessID.text!, "accesskey":txtAccessKey.text!]) { (response, error) in
                
                indicator.dismiss()
                if(error == nil){
                    let ec2Result : EC2WatchResultViewController = EC2View.instantiateViewController(withIdentifier: "ec2result") as! EC2WatchResultViewController
                    
                    if(PFUser.current() != nil && self.pSwitch != nil){
                        if(self.pSwitch.isOn == true){
                            ec2Result.storeInstance = true
                        }
                    }
    
                    ec2Result.accessID = self.txtAccessID.text!
                    ec2Result.accessKey = self.txtAccessKey.text!
                    ec2Result.instanceID = self.txtInstanceID.text!
                    ec2Result.region = self.region
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
        } catch VMWEC2InputParserError.EmptyAccessKey {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Access ID is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWEC2InputParserError.EmptySecretKey {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Secret key is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWEC2InputParserError.EmptyInstanceID {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Instance ID is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWEC2InputParserError.EmptyRegion {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Please select a region",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch let error as NSError {
            NSLog("Error with request: \(error)")
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Unexpected Error",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }
    }
}
