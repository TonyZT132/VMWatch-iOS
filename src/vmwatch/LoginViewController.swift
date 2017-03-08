//
//  LoginViewController.swift
//  vmwatch
//
//  Created by Yanrong Wang on 2017-03-08.
//  Copyright © 2017 ECE496. All rights reserved.

import UIKit
import AVFoundation
//import OnePasswordExtension

//MARK: - LFTimePickerDelegate
public protocol LoginViewControllerDelegate: class {
    
    /// LoginViewControllerDelegate: Called after pressing 'Login' or 'Signup
    func loginDidFinish(email: String, password: String, type: LoginViewController.SendType)
    
    func forgotPasswordTapped(email: String)
}

public class LoginViewController: UIViewController {
    
    // MARK: - Variables
    var txtPhoneNumber: UITextField!
    var txtPassword: UITextField!
    
    var imgvUserIcon: UIImageView!
    var imgvPasswordIcon: UIImageView!
    var imgvLogo: UIImageView!
    
    var loginView: UIView!
    var bottomTxtPhoneView: UIView!
    var bottomTxtPasswordView: UIView!
    
    var butLogin: UIButton!
    var butDismiss: UIButton!
    
    var appName = ""
    var appUrl = ""
    
    var isLogin = true
    
    let inputParser = VMWUserInfoInputParser()
    let alert = VMWAlertView()
    
    public weak var delegate: LoginViewControllerDelegate?
    public enum SendType {
        
        case Login
    }
    
    // MARK: Customizations
    
    /// URL of the background video
    public var videoURL: NSURL? {
        didSet {
            setupVideoBackgrond()
        }
    }
    
    /// Logo on the top of the Login page
    public var logo: UIImage? {
        didSet {
            setupLoginLogo()
        }
    }
    
    public var loginButtonColor: UIColor? {
        didSet {
            setupLoginButton()
        }
    }
    
    // MARK: - Methods
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.set_view()
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
        //self.set_view()(nibName: nil, bundle: nil)
        
        print("layout")
        var imageView   = UIImageView(frame: self.view.bounds);
        imageView.image = UIImage(named: "background.png")!
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        //view.backgroundColor = UIColor(red: 224 / 255, green: 68 / 255, blue: 98 / 255, alpha: 1)
        
        // setupVideoBackgrond()
        // setupLoginLogo()
        
        // Login
        self.logo = UIImage(named:"icon")
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
    
    // MARK: Background Video Player
    func setupVideoBackgrond() {
        
        var theURL = NSURL()
        if let url = videoURL {
            
            let shade = UIView(frame: self.view.frame)
            shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            view.addSubview(shade)
            view.sendSubview(toBack: shade)
            
            theURL = url
            
            var avPlayer = AVPlayer()
            avPlayer = AVPlayer(url: theURL as URL)
            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            avPlayer.volume = 0
            avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
            
            avPlayerLayer.frame = view.layer.bounds
            
            let layer = UIView(frame: self.view.frame)
            view.backgroundColor = UIColor.clear
            view.layer.insertSublayer(avPlayerLayer, at: 0)
            view.addSubview(layer)
            view.sendSubview(toBack: layer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
            //			NotificationCenter.default().addObserver(self,
            //				selector: #selector(playerItemDidReachEnd(_:)),
            //				name: AVPlayerItemDidPlayToEndTimeNotification,
            //				object: avPlayer.currentItem)
            
            avPlayer.play()
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        
        if let p = notification.object as? AVPlayerItem {
            p.seek(to: kCMTimeZero)
        }
    }
    
    // MARK: Login Logo
    func setupLoginLogo() {
        let logo_size = view.bounds.width * 0.5
        let logoFrame = CGRect(x: (self.view.bounds.width - logo_size) / 2, y: self.view.bounds.height * 0.1, width: logo_size, height: logo_size)
        imgvLogo = UIImageView(frame: logoFrame)
        
        if let loginLogo = logo {
            
            imgvLogo.image = loginLogo
            
            view.addSubview(imgvLogo)
        }
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
        
        imgvUserIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let bundle = Bundle(for: LoginViewController.self)
        imgvUserIcon.image = UIImage(named: "user", in: bundle, compatibleWith: nil)
        loginView.addSubview(imgvUserIcon)
        
        txtPhoneNumber = UITextField(frame: CGRect(x: imgvUserIcon.frame.width + 5, y: 0, width: loginView.frame.width - imgvUserIcon.frame.width - 5, height: 30))
        txtPhoneNumber.delegate = self
        txtPhoneNumber.returnKeyType = .next
        txtPhoneNumber.autocapitalizationType = .none
        txtPhoneNumber.autocorrectionType = .no
        txtPhoneNumber.textColor = UIColor.white
        txtPhoneNumber.keyboardType = .emailAddress
        txtPhoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        loginView.addSubview(txtPhoneNumber)
        
        bottomTxtPhoneView = UIView(frame: CGRect(x: txtPhoneNumber.frame.minX - imgvUserIcon.frame.width - 5, y: txtPhoneNumber.frame.maxY + 5, width: loginView.frame.width, height: 1))
        bottomTxtPhoneView.backgroundColor = .white
        bottomTxtPhoneView.alpha = 0.5
        loginView.addSubview(bottomTxtPhoneView)
    }
    
    func setupPasswordField() {
        
        imgvPasswordIcon = UIImageView(frame: CGRect(x: 0, y: txtPhoneNumber.frame.maxY + 10, width: 30, height: 30))
        
        let bundle = Bundle(for: LoginViewController.self)
        imgvPasswordIcon.image = UIImage(named: "password", in: bundle, compatibleWith: nil)
        loginView.addSubview(imgvPasswordIcon)
        
        txtPassword = UITextField(frame: CGRect(x: imgvPasswordIcon.frame.width + 5, y: txtPhoneNumber.frame.maxY + 10, width: loginView.frame.width - imgvPasswordIcon.frame.width - 5, height: 30))
        txtPassword.delegate = self
        txtPassword.returnKeyType = .done
        txtPassword.isSecureTextEntry = true
        txtPassword.textColor = UIColor.white
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        loginView.addSubview(txtPassword)
        
        bottomTxtPasswordView = UIView(frame: CGRect(x: txtPassword.frame.minX - imgvPasswordIcon.frame.width - 5, y: txtPassword.frame.maxY + 5, width: loginView.frame.width, height: 1))
        bottomTxtPasswordView.backgroundColor = .white
        bottomTxtPasswordView.alpha = 0.5
        loginView.addSubview(bottomTxtPasswordView)
    }
    
    func setupLoginButton() {
        
        butLogin = UIButton(frame: CGRect(x: 0, y: bottomTxtPasswordView.frame.maxY + 30, width: loginView.frame.width, height: 40))
        
        var buttonColor = UIColor()
        if let color = loginButtonColor {
            
            buttonColor = color
        } else {
            buttonColor = UIColor(red: 1 / 255, green: 61 / 255, blue: 123 / 255, alpha: 0.8)
        }
        butLogin.backgroundColor = buttonColor
        
        butLogin.setTitle("Login", for: .normal)
        butLogin.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        butLogin.layer.cornerRadius = 5
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
    
    // MARK: Button Handlers
    func sendTapped() {
        
        let type = SendType.Login
        
        delegate?.loginDidFinish(email: self.txtPhoneNumber.text!, password: self.txtPassword.text!, type: type)
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
    
    
    func forgotPasswordTapped() {
        
        delegate?.forgotPasswordTapped(email: self.txtPhoneNumber.text!)
    }
    
    
    
    // MARK: - Wrong Info Shake Animations
    
    public func wrongInfoShake() {
        
        self.setWrongUI()
        self.txtPhoneNumber.shake()
        self.txtPassword.shake()
        self.setRightUI()
    }
    
    func setWrongUI() {
        
        UIView.animate(withDuration: 5) {
            
            self.butLogin.backgroundColor = .red
            self.butLogin.setTitle("Wrong Info", for: .normal)
            self.bottomTxtPhoneView.backgroundColor = .red
            self.bottomTxtPasswordView.backgroundColor = .red
        }
    }
    
    func setRightUI() {
        
        UIView.animate(withDuration: 1) {
            
            self.butLogin.removeFromSuperview()
            self.setupLoginButton()
            self.bottomTxtPhoneView.backgroundColor = .white
            self.bottomTxtPasswordView.backgroundColor = .white
        }
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    // Animating alpha of bottom line and password icons
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtPhoneNumber {
            
            UIView.animate(withDuration: 1, animations: {
                self.bottomTxtPhoneView.alpha = 1
                self.imgvUserIcon.alpha = 1
                
                self.bottomTxtPasswordView.alpha = 0.2
                self.imgvPasswordIcon.alpha = 0.2
            })
        } else {
            
            UIView.animate(withDuration: 1, animations: {
                self.imgvUserIcon.alpha = 0.2
                self.bottomTxtPhoneView.alpha = 0.2
                
                self.bottomTxtPasswordView.alpha = 1
                self.imgvPasswordIcon.alpha = 1
            })
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Moving signup button down, showing forgot password
        
        self.imgvUserIcon.alpha = 1
        self.bottomTxtPhoneView.alpha = 1
        
        self.bottomTxtPasswordView.alpha = 1
        self.imgvPasswordIcon.alpha = 1
        
    }
    
    // Dealing with return key on keyboard
    public func textFieldShouldReturn(_
        textField: UITextField) -> Bool {
        
        if textField == txtPhoneNumber {
            
            self.txtPassword.becomeFirstResponder()
        } else {
            
            self.txtPassword.resignFirstResponder()
        }
        
        return true
    }
}


