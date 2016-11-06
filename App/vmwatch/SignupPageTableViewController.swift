//
//  SignupPageTableViewController.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-11.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class SignupPageTableViewController: UITableViewController, RSKImageCropViewControllerDelegate {

    let inputParser = VMWInputParser()
    let alert = VMWAlertView()
    var usernameInput:String?
    var croppedImage: UIImage!
    
    @IBOutlet weak var nickNameInputVIew: UITextField!
    @IBOutlet weak var passwordInputView: UITextField!
    @IBOutlet weak var retypePasswordInputView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
            case 0:
                return 1
            case 1:
                return 2
            default:
                return 0
        }
    }
    
    @IBAction func submitSignupRequest(_ sender: AnyObject) {
        do{
            try inputParser.nickNameInputParser(nickname: nickNameInputVIew.text)
            try inputParser.passwordParser(password: passwordInputView.text, retypedPassword: retypePasswordInputView.text)
            
            /*Setup alert for photo selection type menu (take photo or choose existing photo)*/
            let optionMenu = UIAlertController(title: nil, message: "Upload profile image", preferredStyle: .actionSheet)
            
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
            
            let noPhotoAction = UIAlertAction(title: "Skip this step", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.croppedImage = UIImage(named: "non_user")
                self.doSignup()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in })
            
            /*Add all actions*/
            optionMenu.addAction(photoPickAction)
            optionMenu.addAction(noPhotoAction)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
            
        } catch VMWInputParserError.EmptyNickname {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Nickname is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWInputParserError.InvalidNicknameLength {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Nickname length should be between 1 to 20 charcters",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWInputParserError.EmptyPasswordInput {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Password or re-typed password is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWInputParserError.InvalidPasswordLength {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Password length should be between 7 to 18 charcters",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWInputParserError.PasswordDidNotMatch {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Password and re-typed password did not match",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch {
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
    
    private func doSignup(){
        let user:PFUser = PFUser()
        user.username = registeredUser?.getUsername()
        user.password = passwordInputView.text!
        user["nickname"] = nickNameInputVIew.text!
        
        /*Resize the image*/
        let imageData = UIImageJPEGRepresentation(self.croppedImage, 0.2)
        let imageFile = PFFile (data:imageData!)
        user["profileImage"] = imageFile
        
        indicator.showWithMessage(context: "Signing up")
        user.signUpInBackground { (success, signinError) in
            if(signinError == nil){
                registeredUser?.setRegisterStatus(status: true)
                
                PFCloud.callFunction(inBackground: "deleteValidationRecord", withParameters: ["number": user.username!]) { (response, error) in
                    if(error == nil){
                        let isDeleted = response as! Bool
                        if(isDeleted == true){
                            indicator.dismiss()
                            indicator.showWithMessage(context: "Logging in")
                            PFUser.logInWithUsername(inBackground: user.username!, password: user.password!, block: {
                                (loggedUser, loggingError) in
                                
                                if(loggingError == nil){
                                    print("Log in Success")
                                    self.dismiss(animated: true, completion: nil)
                                }else{
                                    self.present(
                                        self.alert.showAlertWithOneButton(
                                            title: "Error",
                                            message: "Login Failed, please try again or contact customer service",
                                            actionButton: "OK"
                                        ),
                                        animated: true,
                                        completion: nil
                                    )
                                }
                            })
                        } else {
                            self.present(
                                self.alert.showAlertWithOneButton(
                                    title: "Error",
                                    message: "Backend error, please try again or contact customer service",
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
                                message: "Sign up Failed, please try again or contact customer service",
                                actionButton: "OK"
                            ),
                            animated: true,
                            completion: nil
                        )
                    }
                }
            }else{
                self.present(
                    self.alert.showAlertWithOneButton(
                        title: "Error",
                        message: signinError.debugDescription,
                        actionButton: "OK"
                    ),
                    animated: true,
                    completion: nil
                )
            }
        }
    }
    
    @IBAction func cancelSignup(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Image cropper delegate
    
    /*Get the cropped image*/
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.croppedImage = croppedImage
        self.navigationController?.dismiss(animated: true, completion: nil)
        self.doSignup()
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        return
    }
}
