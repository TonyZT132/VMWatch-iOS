
//
//  LoginViewController.swift
//  vmwatch
//
//  Created by Yanrong Wang on 2017-03-08.
//  Copyright © 2017 ECE496. All rights reserved.

import UIKit

public class LoginViewController: UIViewController {
    
    // MARK: - Variables
    var txtPhoneNumber: UITextField!
    var txtPassword: UITextField!
    
    //initialize views used for login page
    var logoImg: UIImageView!
    var logoBlur: UIView!
    var loginView: UIView!
    var bottomTxtPhoneView: UIView!
    var bottomTxtPasswordView: UIView!
    
    var butLogin: UIButton!
    var butDismiss: UIButton!
    
    let inputParser = VMWUserInfoInputParser()
    let alert = VMWAlertView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.set_view()
        //hide keyboard when tapped around
        self.hideKeyboardWhenTappedAround()
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
        setupLoginLogo()
        setupLoginView()
        setupPhoneField()
        setupPasswordField()
        setupLoginButton()
        setupDismissButton()
        
        view.addSubview(loginView)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Login Logo
    func setupLoginLogo() {
        let logo_size : CGFloat = view.bounds.width * 0.5
        let logo_x : CGFloat = (self.view.bounds.width - logo_size) / 2
        let logo_y : CGFloat = self.view.bounds.height * 0.1
        //set up blur background for logo
        setupLogoBlur(logo_size: logo_size,logo_x: logo_x,logo_y: logo_y)
        logoImg = UIImageView(frame:CGRect(x: logo_x, y: logo_y, width: logo_size, height: logo_size))
        logoImg.image = UIImage(named: "icon")!
        view.addSubview(logoImg)
    }
    
    func setupLogoBlur (logo_size: CGFloat,logo_x: CGFloat,logo_y: CGFloat){
        //generate blur background for logo
        let circle = UIView(frame: CGRect(x: logo_x, y: logo_y, width: logo_size, height: logo_size))
        circle.layer.cornerRadius = logo_size * 0.5
        circle.backgroundColor = UIColor.white
        circle.alpha = 0.2
        circle.clipsToBounds = true
        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurView = UIVisualEffectView(effect: lightBlur)
        blurView.frame = circle.bounds
        circle.addSubview(blurView)
        self.view.addSubview(circle)
    }
    
    // MARK: Login View
    func setupLoginView() {
        let loginX: CGFloat = self.view.bounds.width * 0.05
        let loginY = CGFloat(self.view.bounds.height * 0.6)
        let loginWidth = self.view.bounds.width * 0.9
        let loginHeight: CGFloat = self.view.bounds.height - loginY
        print(loginHeight)
        loginView = UIView(frame: CGRect(x: loginX, y: loginY, width: loginWidth, height: loginHeight))
    }
    
    func setupPhoneField() {
        txtPhoneNumber = UITextField(frame: CGRect(x: 0 , y: 0, width: loginView.frame.width, height: 30))
        txtPhoneNumber.returnKeyType = .next
        txtPhoneNumber.textColor = UIColor.white
        txtPhoneNumber.keyboardType = .phonePad
        txtPhoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        loginView.addSubview(txtPhoneNumber)
        //add buttom boarder for text field
        bottomTxtPhoneView = UIView(frame: CGRect(x: txtPhoneNumber.frame.minX, y: txtPhoneNumber.frame.maxY + 5, width: loginView.frame.width, height: 1))
        bottomTxtPhoneView.backgroundColor = .white
        bottomTxtPhoneView.alpha = 0.5
        loginView.addSubview(bottomTxtPhoneView)
    }
    
    func setupPasswordField() {
        txtPassword = UITextField(frame: CGRect(x: 0, y: txtPhoneNumber.frame.maxY + 10, width: loginView.frame.width - 5, height: 30))
        txtPassword.returnKeyType = .done
        txtPassword.isSecureTextEntry = true
        txtPassword.textColor = UIColor.white
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        loginView.addSubview(txtPassword)
        //add buttom boarder for text field
        bottomTxtPasswordView = UIView(frame: CGRect(x: txtPassword.frame.minX, y: txtPassword.frame.maxY + 5, width: loginView.frame.width, height: 1))
        bottomTxtPasswordView.backgroundColor = .white
        bottomTxtPasswordView.alpha = 0.5
        loginView.addSubview(bottomTxtPasswordView)
    }
    
    func setupLoginButton() {
        butLogin = UIButton(frame: CGRect(x: 0, y: bottomTxtPasswordView.frame.maxY + 30, width: loginView.frame.width, height: 40))
        butLogin.backgroundColor = UIColor(red: 1 / 255, green: 61 / 255, blue: 123 / 255, alpha: 0.8)
        butLogin.setTitle("Login", for: .normal)
        butLogin.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        butLogin.layer.cornerRadius = butLogin.frame.height * 0.5
        butLogin.layer.borderWidth = 1
        butLogin.layer.borderColor = UIColor.clear.cgColor
        loginView.addSubview(butLogin)
    }
    
    func setupDismissButton() {
        butDismiss = UIButton(frame: CGRect(x: 0, y: butLogin.frame.maxY, width: loginView.frame.width, height: 40))
        let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        let titleString = NSAttributedString(string: "Back", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        butDismiss.setAttributedTitle(titleString, for: .normal)
        butDismiss.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        loginView.addSubview(butDismiss)
    }
    
 
    func loginTapped(_ sender: AnyObject) {
        do{
            try inputParser.digitNumberParser(content: txtPhoneNumber.text, length: 10)
            if(txtPassword.text == nil || txtPassword.text == ""){
                throw VMWUserDataInputParserError.EmptyPasswordInput
            }
            
            indicator.showWithMessage(context: "Logging")
            PFUser.logInWithUsername(inBackground: txtPhoneNumber.text!, password: txtPassword.text!, block: { (loggedUser, loggingError) in
                if(loggingError == nil){
                    registeredUser = VMWRegisteredUser(usernameInput: self.txtPhoneNumber.text!)
                    registeredUser?.setLoginStatus(status: true)
                    /*set up loading screen*/
                    self.dismiss(animated: true, completion: nil)
                }else{
                    indicator.dismiss()
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
        } catch VMWUserDataInputParserError.EmptyPhoneNumber {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Phone number is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWUserDataInputParserError.InvalidDigitNumber {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Phone number is invalid",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWUserDataInputParserError.EmptyPasswordInput {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Password is empty",
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
    
    
    func dismissTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //move view up by keyboardSize.height when keyboard is visible
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
}

//hide keyboard when touching anywhere outside
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
