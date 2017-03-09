//
//  SignupPageViewController.swift
//  vmwatch
//
//  Created by Yanrong Wang on 2017-03-09.
//  Copyright © 2017 ECE496. All rights reserved.
//

import UIKit

public class SingupPageViewController: UIViewController,RSKImageCropViewControllerDelegate { 
    
    // MARK: - Variables
    var txtName: UITextField!
    var txtPassword_1: UITextField!
    var txtPassword_2: UITextField!
    var butSubmit: UIButton!
    var butDismiss: UIButton!
    var bottomTxtNameView: UIView!
    var bottomTxtPasswordView_1: UIView!
    var bottomTxtPasswordView_2: UIView!
    var signupView: UIView!
    var croppedImage: UIImage!
    
    let inputParser = VMWUserInfoInputParser()
    let alert = VMWAlertView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.set_view()
        //hide keyboard when tapped around
        self.hideKeyboardWhenTappedAround()
        //Adding notifies on keyboard appearing
        //move view up/down when keyboard is shown/hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        
        // Adding Navigation bar again
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        
        // Removing Navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func viewWillLayoutSubviews() {
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    private func set_view() {
        let imageView   = UIImageView(frame: self.view.bounds);
        imageView.image = UIImage(named: "background")!
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        // Login
        setupSignupTitle()
        setupSignupView()
        setupNameField()
        setupPasswordField()
        setupSubmitButton()
        setupDismissButton()
        
        view.addSubview(signupView)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSignupTitle (){
        let title_x: CGFloat = self.view.bounds.width * 0.1
        let title_y: CGFloat = self.view.bounds.height * 0.15
        let title_width: CGFloat = self.view.bounds.width * 0.8
        let title_height: CGFloat = 40
        let textView = UILabel(frame: CGRect(x: title_x, y: title_y, width: title_width, height: title_height))
        self.automaticallyAdjustsScrollViewInsets = false
        textView.text = "SIGN UP"
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor(white: 1, alpha: 0)
        textView.font = UIFont.boldSystemFont(ofSize: 22)
        view.addSubview(textView)
        
    }
    
    // MARK: Validation View
    func setupSignupView() {
        let x: CGFloat = self.view.bounds.width * 0.05
        let y = CGFloat(self.view.bounds.height * 0.55)
        let width = self.view.bounds.width * 0.9
        let height: CGFloat = self.view.bounds.height - y
        signupView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    }
    
    func setupNameField() {
        //set up text field for phone number input takes 0.7 of width
        txtName = UITextField(frame: CGRect(x: 0 , y: 0, width: signupView.frame.width, height: 30))
        txtName.returnKeyType = .next
        txtName.autocorrectionType = .no
        txtName.textColor = UIColor.white
        txtName.attributedPlaceholder = NSAttributedString(string: "Nick Name", attributes: [NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        signupView.addSubview(txtName)
        
        //add buttom boarder for text field
        bottomTxtNameView = UIView(frame: CGRect(x: 0, y: txtName.frame.maxY + 5, width: signupView.frame.width, height: 1))
        bottomTxtNameView.backgroundColor = .white
        bottomTxtNameView.alpha = 0.5
        signupView.addSubview(bottomTxtNameView)
    }
    
    func setupPasswordField() {
        txtPassword_1 = UITextField(frame: CGRect(x: 0, y: txtName.frame.maxY + 10, width: signupView.frame.width - 5, height: 30))
        txtPassword_1.returnKeyType = .next
        txtPassword_1.isSecureTextEntry = true
        txtPassword_1.textColor = UIColor.white
        txtPassword_1.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        signupView.addSubview(txtPassword_1)
        
        //add buttom boarder for text field
        bottomTxtPasswordView_1 = UIView(frame: CGRect(x: 0, y: txtPassword_1.frame.maxY + 5, width: signupView.frame.width, height: 1))
        bottomTxtPasswordView_1.backgroundColor = .white
        bottomTxtPasswordView_1.alpha = 0.5
        signupView.addSubview(bottomTxtPasswordView_1)
        
        //set re-enter password view
        txtPassword_2 = UITextField(frame: CGRect(x: 0, y: txtPassword_1.frame.maxY + 10, width: signupView.frame.width - 5, height: 30))
        txtPassword_2.returnKeyType = .done
        txtPassword_2.isSecureTextEntry = true
        txtPassword_2.textColor = UIColor.white
        txtPassword_2.attributedPlaceholder = NSAttributedString(string: "Re-enter Password", attributes: [NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        signupView.addSubview(txtPassword_2)
        
        //add buttom boarder for text field
        bottomTxtPasswordView_2 = UIView(frame: CGRect(x: 0, y: txtPassword_2.frame.maxY + 5, width: signupView.frame.width, height: 1))
        bottomTxtPasswordView_2.backgroundColor = .white
        bottomTxtPasswordView_2.alpha = 0.5
        signupView.addSubview(bottomTxtPasswordView_2)
    }
    
    func setupSubmitButton() {
        butSubmit = UIButton(frame: CGRect(x: 0, y: bottomTxtPasswordView_2.frame.maxY + 30, width: signupView.frame.width, height: 40))
        butSubmit.backgroundColor = UIColor(red: 1 / 255, green: 61 / 255, blue: 123 / 255, alpha: 0.8)
        butSubmit.setTitle("Submit", for: .normal)
        butSubmit.addTarget(self,action: #selector(submitTapped), for: .touchUpInside)
        butSubmit.layer.cornerRadius = butSubmit.frame.height * 0.5
        butSubmit.layer.borderWidth = 1
        butSubmit.layer.borderColor = UIColor.clear.cgColor
        signupView.addSubview(butSubmit)
    }
    
    func setupDismissButton() {
        butDismiss = UIButton(frame: CGRect(x: 0, y: butSubmit.frame.maxY, width: signupView.frame.width, height: 40))
        let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        let titleString = NSAttributedString(string: "Back", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        butDismiss.setAttributedTitle(titleString, for: .normal)
        butDismiss.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        signupView.addSubview(butDismiss)
    }
    
    
    func submitTapped(_ sender: AnyObject) {
        //send phone number to server for sending verification code
        do{
            try inputParser.nickNameInputParser(nickname: txtName.text)
            try inputParser.passwordParser(password: txtPassword_1.text, retypedPassword: txtPassword_2.text)
            
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
            
        } catch VMWUserDataInputParserError.EmptyNickname {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Nickname is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWUserDataInputParserError.InvalidNicknameLength {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Nickname length should be between 1 to 20 charcters",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWUserDataInputParserError.EmptyPasswordInput {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Password or re-typed password is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWUserDataInputParserError.InvalidPasswordLength {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Password length should be between 7 to 18 charcters",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWUserDataInputParserError.PasswordDidNotMatch {
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
        do{
            let user:PFUser = PFUser()
            user.username = try registeredUser?.getUsername()
            user.password = txtPassword_1.text!
            user["nickname"] = txtName.text!
            
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
        } catch {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Error occured while getting user info",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }
    }
    
    /*Get the cropped image*/
    public func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.croppedImage = croppedImage
        self.navigationController?.dismiss(animated: true, completion: nil)
        self.doSignup()
    }
    
    public func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        return
    }

    func dismissTapped(){
        self.dismiss(animated: true, completion: nil)
    }
}
