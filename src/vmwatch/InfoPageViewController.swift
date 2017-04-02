//
//  InfoPageViewController.swift
//  vmwatch
//
//  Created by Yuxuan Zhang on 2017-03-10.
//  Copyright © 2017 ECE496. All rights reserved.
//

import UIKit
import CoreData


public class InfoPageViewController: UIViewController, RSKImageCropViewControllerDelegate {
    
    // MARK: - Variables
    
    //initialize views used for login page
    var profileImg: UIImageView!
    var loginView: UIView!
    var userName: UILabel!
    
    // For setup phone
    var phoneNumber: UILabel!
    var phoneNumberRightHand: UILabel!
    var bottomTxtPhoneView: UIView!
    
    // For setup local VM
    var localVM: UILabel!
    var localVMNumber: UILabel!
    var bottomVMView: UIView!
    
    // For setup Server VM
    var serverVM: UILabel!
    var serverVMNumber: UILabel!
    var bottomVMServerView: UIView!
    
    // For button
    var butLogin: UIButton!
    var butLogout: UIButton!
    var butShowList: UIButton!
    
    // For setup background
    var topBackgroundImg: UIImageView!
    var botBackgroundImg: UIView!
    
    
    let inputParser = VMWUserInfoInputParser()
    let alert = VMWAlertView()
    var croppedImage: UIImage!
    
    var userImg = UIImage(named: "non_user")
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        //hide keyboard when tapped around
        self.hideKeyboardWhenTappedAround()
        //move view up/down when keyboard is shown/hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        
        // Adding Navigation bar again
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if(PFUser.current() == nil){
            setupBackground()
            setupLoginView()
            setupClearHistoryButton()
            setupLocalVM()
            setupProfileImg(img_name: UIImage(named: "non_user")!)
            setupName(name: "Guest")
            view.addSubview(loginView)
            
        }else{
            let userName = PFUser.current()?.object(forKey: "nickname") as? String
            let phoneNumber = PFUser.current()?.object(forKey: "username") as? String
            let userImageFile = PFUser.current()!.object(forKey: "profileImage")  as! PFFile
            
            setupBackground()
            setupLoginView()
            setupClearHistoryButton()
            setupShowListButton()
            setupLogoutButton()
            setupPhoneNumber(phone: phoneNumber!)
            setupLocalVM()
            setupServerVM()
            setupProfileImg(img_name: userImg!)
            setupName(name: userName!)
            
            userImageFile.getDataInBackground(block: { (imageData, error) in
                if(error == nil){
                    if (imageData != nil) {
                        self.userImg = UIImage(data:imageData!)
                        self.profileImg.image = self.userImg
                    }
                }else{
                    self.userImg = UIImage(named: "non_user")
                }
            })
            
            view.addSubview(loginView)
        }
    }
    
    public override func viewWillLayoutSubviews() {
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLoginView() {
        let loginX: CGFloat = self.view.bounds.width * 0.05
        let loginY = CGFloat(self.view.bounds.height * 0.3)
        let loginWidth = self.view.bounds.width * 0.9
        let loginHeight: CGFloat = self.view.bounds.height - loginY
        loginView = UIView(frame: CGRect(x: loginX, y: loginY, width: loginWidth, height: loginHeight))
    }
    
    func setupProfileImg(img_name: UIImage){
        let logo_size : CGFloat = view.bounds.width * 0.3
        let logo_x : CGFloat = (self.view.bounds.width - logo_size) / 2
        let logo_y : CGFloat = self.view.bounds.height * 0.05
        //set up blur background for logo
        profileImg = UIImageView(frame:CGRect(x: logo_x, y: logo_y, width: logo_size, height: logo_size))
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        profileImg.image = img_name
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doIMG))
        profileImg.isUserInteractionEnabled = true
        profileImg.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(profileImg)
    }
    
    func setupClearHistoryButton() {
        butLogin = UIButton(frame: CGRect(x: 0, y: loginView.bounds.height*0.6, width: loginView.frame.width, height: 40))
        butLogin.backgroundColor = UIColor(red: 0 / 255, green: 146 / 255, blue: 206 / 255, alpha: 0.8)
        butLogin.setTitle("Clear History", for: .normal)
        butLogin.addTarget(self, action: #selector(doDeleteHistory), for: .touchUpInside)
        butLogin.layer.cornerRadius = butLogin.frame.height * 0.5
        butLogin.layer.borderWidth = 1
        butLogin.layer.borderColor = UIColor.clear.cgColor
        loginView.addSubview(butLogin)
    }
    
    func setupLogoutButton() {
        butLogout = UIButton(frame: CGRect(x: 0, y: butLogin.frame.maxY+20, width: loginView.frame.width, height: 40))
        butLogout.backgroundColor = UIColor(red: 220 / 255, green: 60 / 255, blue: 34 / 255, alpha: 0.8)
        butLogout.setTitle("Log Out", for: .normal)
        butLogout.addTarget(self, action: #selector(doLogout), for: .touchUpInside)
        butLogout.layer.cornerRadius = butLogout.frame.height * 0.5
        butLogout.layer.borderWidth = 1
        butLogout.layer.borderColor = UIColor.clear.cgColor
        loginView.addSubview(butLogout)
    }
    
    func setupName(name: String){
        let name_y : CGFloat = self.view.bounds.height * 0.05 + self.view.bounds.width * 0.3 + 10
        userName = UILabel(frame: CGRect(x: 0 , y: name_y, width: self.view.bounds.width, height: 30))
        userName.textColor =  UIColor(red: 239 / 255, green: 239 / 255, blue: 245 / 255, alpha: 0.8)
        userName.attributedText = NSAttributedString(string: name)
        userName.textAlignment = NSTextAlignment.center
        view.addSubview(userName)
    }
    
    func setupPhoneNumber(phone: String){
        phoneNumber = UILabel(frame:CGRect(x: 0 , y: 0, width: loginView.bounds.width, height: 30))
        phoneNumber.textColor = UIColor(red: 196 / 255, green: 195 / 255, blue: 212 / 255, alpha: 0.8)
        phoneNumber.attributedText = NSAttributedString(string: "Phone Number:")
        loginView.addSubview(phoneNumber)
        //add buttom boarder for text field
        bottomTxtPhoneView = UIView(frame: CGRect(x: phoneNumber.frame.minX, y: phoneNumber.frame.maxY + 5, width: loginView.frame.width, height: 1))
        bottomTxtPhoneView.backgroundColor = UIColor(red: 196 / 255, green: 195 / 255, blue: 212 / 255, alpha: 0.8)
        bottomTxtPhoneView.alpha = 0.5
        loginView.addSubview(bottomTxtPhoneView)
        //add number to the right hand side
        phoneNumberRightHand = UILabel(frame:CGRect(x: 0 , y: 0, width: loginView.bounds.width, height: 30))
        phoneNumberRightHand.textAlignment = NSTextAlignment.right
        phoneNumberRightHand.textColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 245 / 255, alpha: 0.8)
        phoneNumberRightHand.attributedText = NSAttributedString(string: phone)
        loginView.addSubview(phoneNumberRightHand)
        
    }
    
    func setupLocalVM() {
        localVM = UILabel(frame:CGRect(x: 0 , y: 40, width: loginView.bounds.width, height: 30))
        localVM.textColor = UIColor(red: 196 / 255, green: 195 / 255, blue: 212 / 255, alpha: 0.8)
        localVM.attributedText = NSAttributedString(string: "Number of VM on Local:")
        loginView.addSubview(localVM)
        //add buttom boarder for text field
        bottomVMView = UIView(frame: CGRect(x: localVM.frame.minX, y: localVM.frame.maxY + 5, width: loginView.frame.width, height: 1))
        bottomVMView.backgroundColor = UIColor(red: 196 / 255, green: 195 / 255, blue: 212 / 255, alpha: 0.8)
        bottomVMView.alpha = 0.5
        loginView.addSubview(bottomVMView)
        //add number to the right hand side
        localVMNumber = UILabel(frame:CGRect(x: 0 , y: 40, width: loginView.bounds.width, height: 30))
        localVMNumber.textAlignment = NSTextAlignment.right
        localVMNumber.textColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 245 / 255, alpha: 0.8)
        let number_in_local = countServiceInLocal()
        localVMNumber.attributedText = NSAttributedString(string: number_in_local)
        loginView.addSubview(localVMNumber)
  
    }
    
    func setupServerVM(){
        serverVM = UILabel(frame:CGRect(x: 0 , y: localVM.frame.maxY + 10, width: loginView.bounds.width, height: 30))
        serverVM.textColor = UIColor(red: 196 / 255, green: 195 / 255, blue: 212 / 255, alpha: 0.8)
        serverVM.attributedText = NSAttributedString(string: "Number of VM on Server:")
        loginView.addSubview(serverVM)
        //add buttom boarder for text field
        bottomVMServerView = UIView(frame: CGRect(x: serverVM.frame.minX, y: serverVM.frame.maxY + 5, width: loginView.frame.width, height: 1))
        bottomVMServerView.backgroundColor = UIColor(red: 196 / 255, green: 195 / 255, blue: 212 / 255, alpha: 0.8)
        bottomVMServerView.alpha = 0.5
        loginView.addSubview(bottomVMServerView)
        
        //add number to the right hand side
        serverVMNumber = UILabel(frame:CGRect(x: 0 , y: localVM.frame.maxY + 10, width: loginView.bounds.width, height: 30))
        serverVMNumber.textAlignment = NSTextAlignment.right
        serverVMNumber.textColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 245 / 255, alpha: 0.8)
        serverVMNumber.attributedText = NSAttributedString(string: "0")
        if(PFUser.current() != nil){
            self.getAccessCredential()
        }
        loginView.addSubview(serverVMNumber)
    }
    
    func setupBackground(){
        
        // top part
        let topbackgroundImg_y = self.view.bounds.height * 0.155
        topBackgroundImg = UIImageView(frame: CGRect(x: 0, y:0, width: view.bounds.width , height: self.view.bounds.height ))
        topBackgroundImg.image = UIImage(named: "background")!
        view.addSubview(topBackgroundImg)
        
        // bot part
        let botBackgroundImg_y = self.view.bounds.height * 0.845
        botBackgroundImg = UIView(frame: CGRect(x: 0, y:topbackgroundImg_y, width: view.bounds.width , height: botBackgroundImg_y ))
        botBackgroundImg.backgroundColor = UIColor(red: 39/255, green: 57/255, blue: 74/255, alpha: 1)
        view.addSubview(botBackgroundImg)
    }
    
    func setupShowListButton() {
        butShowList = UIButton(frame: CGRect(x: 0, y: butLogin.frame.maxY-100, width: loginView.frame.width, height: 40))
        butShowList.backgroundColor = UIColor(red: 0 / 255, green: 146 / 255, blue: 206 / 255, alpha: 0.8)
        butShowList.setTitle("Saved VM", for: .normal)
        butShowList.addTarget(self, action: #selector(displayInstanceListView), for: .touchUpInside)
        butShowList.layer.cornerRadius = butLogin.frame.height * 0.5
        butShowList.layer.borderWidth = 1
        butShowList.layer.borderColor = UIColor.clear.cgColor
        loginView.addSubview(butShowList)
    }
    
    
    // Start Function
    func doLogout(_ sender: AnyObject) {
        self.present(
            alert.showAlertWithTwoButton(
                title: "Notice",
                message: "Do you want to log out?",
                actionButtonOne: "Yes",
                actionButtonTwo: "No",
                handlerOne: {() -> Void in
                    PFUser.logOut()
                    let accountMenu : AccountMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "accountMenu") as! AccountMenuViewController
                    self.present(accountMenu, animated: true, completion: nil)
            },
                handlerTwo: {() -> Void in
                    return
            }
            ),
            animated: true,
            completion: nil
        )
    }
    
    func doIMG(_ sender: AnyObject){
        if(PFUser.current() == nil){
            let accountMenu : AccountMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "accountMenu") as! AccountMenuViewController
            self.present(accountMenu, animated: true, completion: nil)
        }else{
            /*Setup alert for photo selection type menu (take photo or choose existing photo)*/
            let optionMenu = UIAlertController(title: nil, message: "Update profile image", preferredStyle: .actionSheet)
            
            /*Setup the photo picker*/
            let photoPickAction = UIAlertAction(title: "Choose from Photos", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                /*Initial the DKimage picker*/
                let pickerController = DKImagePickerController()
                pickerController.maxSelectableCount = 1
                pickerController.didCancel = { () in }
                pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                    if(assets.count == 0){ return }
                    let asset  = assets[0]
                    asset.fetchOriginalImage(true, completeBlock: { (originalImage, error) in
                        if( originalImage != nil){
                            /*Crop the image*/
                            let imageCropVC = RSKImageCropViewController(image: originalImage!)
                            imageCropVC.cropMode = RSKImageCropMode.square
                            imageCropVC.delegate = self
                            self.present(imageCropVC, animated: true, completion:nil)
                        }else{
                            self.present(
                                self.alert.showAlertWithOneButton(
                                    title: "Error",
                                    message: "Error happened while getting the photo",
                                    actionButton: "OK"
                                ),
                                animated: true,
                                completion: nil
                            )
                        }
                    })
                }
                self.present(pickerController, animated: true, completion:nil)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in })
            
            /*Add all actions*/
            optionMenu.addAction(photoPickAction)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
    
    private func pictureUpdate(){
        /*Do update*/
        if let currentUser = PFUser.current(){
            
            /*Resize the image*/
            let imageData = UIImageJPEGRepresentation(self.croppedImage, 0.2)
            let imageFile = PFFile (data:imageData!)
            currentUser["profileImage"] = imageFile
            currentUser.saveInBackground(block: { (success, error) -> Void in
                indicator.dismiss()
                if(error == nil){
                    self.userImg = UIImage(data:imageData!)
                    
                }else{
                    self.present(
                        self.alert.showAlertWithOneButton(
                            title: "Error",
                            message: "Fail to update the profile picture",
                            actionButton: "OK"
                        ),
                        animated: true,
                        completion: nil
                    )
                }
            })
            self.userImg = UIImage(data:imageData!)
            setupProfileImg(img_name: userImg!)
            
            
        }else{
            indicator.dismiss()
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Fail to update the profile picture",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }
    }
    
    func doDeleteHistory(){
        self.present(
            alert.showAlertWithTwoButton(
                title: "Notice",
                message: "Do you want to clear the database?",
                actionButtonOne: "Yes",
                actionButtonTwo: "No",
                handlerOne: {() -> Void in
                    do{
                        try VMWEC2HistoryStorage().clearHistory()
                        try GoogleHistoryStorage().clearHistory()
                        self.present(
                            self.alert.showAlertWithOneButton(
                                title: "Success",
                                message: "Data cleared",
                                actionButton: "OK"
                            ),
                            animated: true,
                            completion: nil                        )
                    } catch {
                        NSLog("Error ocuured when clear the database")
                    }
                    self.viewWillAppear(false)
            },
                handlerTwo: {() -> Void in
                    return
            }
            ),
            animated: true,
            completion: nil
        )
        // update on time
    }
    
    func countServiceInLocal() -> String{
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var google_count = 0
        var aws_count = 0
        do{
            let google_fetchRequest: NSFetchRequest<History_Google> = History_Google.fetchRequest()
            let google_searchResults = try context.fetch(google_fetchRequest)
            google_count = google_searchResults.count
        }catch let error as NSError {
            NSLog("Error with request: \(error)")
        }
        
        do{
            let aws_fetchRequest: NSFetchRequest<History_EC2> = History_EC2.fetchRequest()
            let aws_searchResults = try context.fetch(aws_fetchRequest)
            aws_count = aws_searchResults.count
        }catch let error as NSError {
            NSLog("Error with request: \(error)")
        }
        
        let total_num = google_count + aws_count
        let totalNumberInString = String(total_num)
        
        return totalNumberInString
    }
    
    //MARK: Image cropper delegate
    
    /*Get the cropped image*/
    public func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.croppedImage = croppedImage
        self.navigationController?.dismiss(animated: true, completion: nil)
        indicator.showWithMessage(context: "Updating")
        self.pictureUpdate()
    }
    
    public func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        return
    }
    
    func getAccessCredential(){
        let storeParams = [
            "userid" as NSObject: PFUser.current()?.objectId! as AnyObject
            ] as [NSObject:AnyObject]
        
        PFCloud.callFunction(inBackground: "ec2UserDataGet", withParameters: storeParams) { (response, ec2StoreError) in
            if(ec2StoreError == nil){
                do{
                    let parser = VMWEC2CredentialJSONParser(inputData: response)
                    let arr = try parser.parse()
                    self.serverVMNumber.attributedText = NSAttributedString(string: String(arr.count))
                } catch {
                    NSLog("Fail to get stored credentials")
                }
            }else{
                NSLog("Fail to get stored credentials")
            }
        }
    }
    
    func displayInstanceListView(_ sender: AnyObject){
        let storeParams = [
            "userid" as NSObject: PFUser.current()?.objectId! as AnyObject
            ] as [NSObject:AnyObject]
        
        PFCloud.callFunction(inBackground: "ec2UserDataGet", withParameters: storeParams) { (response, ec2StoreError) in
            if(ec2StoreError == nil){
                do{
                    let parser = VMWEC2CredentialJSONParser(inputData: response)
                    let arr = try parser.parse()
                    
                    let instanceListView : InstanceListViewController = self.storyboard!.instantiateViewController(withIdentifier: "instanceList") as! InstanceListViewController
                    
                    instanceListView.VMList = arr
                    instanceListView.hidesBottomBarWhenPushed = true
                    //self.navigationController!.navigationBar.tintColor = UIColor.white
                    self.navigationController?.pushViewController(instanceListView, animated: true)
                    
                } catch {
                    self.present(
                        self.alert.showAlertWithOneButton(
                            title: "Error",
                            message: "Parser fail",
                            actionButton: "OK"
                        ),
                        animated: true,
                        completion: nil
                    )
                }
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

};
