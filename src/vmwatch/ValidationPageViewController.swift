

//
//  ValidationPageViewController.swift
//  vmwatch
//
//  Created by Yanrong Wang on 2017-03-08.
//  Copyright © 2017 ECE496. All rights reserved.
//

import UIKit

public class ValidationPageViewController: UIViewController {
    
    // MARK: - Variables
    var txtPhoneNumber: UITextField!
    var txtValidationCode: UITextField!
    var butSendCode: UIButton!
    var butValidate: UIButton!
    var butDismiss: UIButton!
    var bottomTxtPhoneView: UIView!
    var bottomTxtValidationView: UIView!
    var validationView: UIView!
    var countLabel: UILabel!
    let alert = VMWAlertView()
    let inputParser = VMWUserInfoInputParser()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.set_view()
        //hide keyboard when tapped around
        self.hideKeyboardWhenTappedAround()
        //move view up/down when keyboard is shown/hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        if(registeredUser != nil && registeredUser?.isRegisted() == true){
            self.dismiss(animated: true, completion: nil)
        }
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
        setupValidationTitle()
        setupValidationView()
        setupPhoneField()
        setupValidationField()
        setupValitationButton()
        setupDismissButton()
        view.addSubview(validationView)
        

    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupValidationTitle (){
        let title_x: CGFloat = self.view.bounds.width * 0.1
        let title_y: CGFloat = self.view.bounds.height * 0.15
        let title_width: CGFloat = self.view.bounds.width * 0.8
        let title_height: CGFloat = 40
        let textView = UILabel(frame: CGRect(x: title_x, y: title_y, width: title_width, height: title_height))
        textView.text = "PHONE VALIDATION"
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor(white: 1, alpha: 0)
        textView.font = UIFont.boldSystemFont(ofSize: 22)
        view.addSubview(textView)
        
    }
    
    // MARK: Validation View
    func setupValidationView() {
        let validation_x: CGFloat = self.view.bounds.width * 0.05
        let validation_y = CGFloat(self.view.bounds.height * 0.6)
        let validation_width = self.view.bounds.width * 0.9
        let validation_height: CGFloat = self.view.bounds.height - validation_y
        validationView = UIView(frame: CGRect(x: validation_x, y: validation_y, width: validation_width, height: validation_height))
    }
    
    func setupPhoneField() {
        //set up text field for phone number input takes 0.7 of width
        txtPhoneNumber = UITextField(frame: CGRect(x: 0 , y: 0, width: validationView.frame.width * 0.7, height: 30))
        txtPhoneNumber.returnKeyType = .next
        txtPhoneNumber.textColor = UIColor.white
        txtPhoneNumber.keyboardType = .phonePad
        txtPhoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        validationView.addSubview(txtPhoneNumber)
        
        //add validation button, takes 0.3 of width
        butSendCode = UIButton(frame: CGRect(x: validationView.frame.width * 0.7 , y: 0, width: validationView.frame.width * 0.3, height: 30))
         butSendCode.backgroundColor = UIColor(red: 1 / 255, green: 61 / 255, blue: 123 / 255, alpha: 0.8)
        let font = UIFont(name: "HelveticaNeue-Medium", size: 13)!
        let titleString = NSAttributedString(string: "Send Code", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        butSendCode.setAttributedTitle(titleString, for: .normal)
        butSendCode.layer.cornerRadius = butSendCode.frame.height * 0.5
        butSendCode.layer.borderWidth = 1
        butSendCode.layer.borderColor = UIColor.clear.cgColor
        butSendCode.addTarget(self, action: #selector(sendCodeTapped), for: .touchUpInside)
        butSendCode.clipsToBounds = true
        validationView.addSubview(butSendCode)
        
        //set countLabel
        countLabel = UILabel(frame: CGRect(x: validationView.frame.width * 0.7 , y: 0, width: validationView.frame.width * 0.3, height: 30))
        countLabel.backgroundColor = UIColor(red: 1 / 255, green: 61 / 255, blue: 123 / 255, alpha: 0.8)
        countLabel.text = "count"
        countLabel.textAlignment = .center
        countLabel.textColor = UIColor(red: 196, green: 195, blue: 212, alpha: 1)
        countLabel.layer.cornerRadius = butSendCode.frame.height * 0.5
        countLabel.layer.borderWidth = 1
        countLabel.layer.borderColor = UIColor.clear.cgColor
        countLabel.clipsToBounds = true
        countLabel.isHidden = true
        validationView.addSubview(countLabel)
        
        //add buttom boarder for text field
        bottomTxtPhoneView = UIView(frame: CGRect(x: 0, y: txtPhoneNumber.frame.maxY + 5, width: validationView.frame.width, height: 1))
        bottomTxtPhoneView.backgroundColor = .white
        bottomTxtPhoneView.alpha = 0.5
        validationView.addSubview(bottomTxtPhoneView)
    }
    
    func setupValidationField() {
        txtValidationCode = UITextField(frame: CGRect(x: 0, y: txtPhoneNumber.frame.maxY + 10, width: validationView.frame.width - 5, height: 30))
        txtValidationCode.returnKeyType = .done
        txtValidationCode.isSecureTextEntry = true
        txtValidationCode.textColor = UIColor.white
        txtValidationCode.keyboardType = .phonePad
        txtValidationCode.attributedPlaceholder = NSAttributedString(string: "Validation Code", attributes: [NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        validationView.addSubview(txtValidationCode)
        
        //add buttom boarder for text field
        bottomTxtValidationView = UIView(frame: CGRect(x: 0, y: txtValidationCode.frame.maxY + 5, width: validationView.frame.width, height: 1))
        bottomTxtValidationView.backgroundColor = .white
        bottomTxtValidationView.alpha = 0.5
        validationView.addSubview(bottomTxtValidationView)
    }
    
    func setupValitationButton() {
        butValidate = UIButton(frame: CGRect(x: 0, y: bottomTxtValidationView.frame.maxY + 30, width: validationView.frame.width, height: 40))
        butValidate.backgroundColor = UIColor(red: 1 / 255, green: 61 / 255, blue: 123 / 255, alpha: 0.8)
        butValidate.setTitle("Validate", for: .normal)
        butValidate.addTarget(self,action: #selector(validateTapped), for: .touchUpInside)
        butValidate.layer.cornerRadius = butValidate.frame.height * 0.5
        butValidate.layer.borderWidth = 1
        butValidate.layer.borderColor = UIColor.clear.cgColor
        validationView.addSubview(butValidate)
    }
    
    func setupDismissButton() {
        butDismiss = UIButton(frame: CGRect(x: 0, y: butValidate.frame.maxY, width: validationView.frame.width, height: 40))
        let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        let titleString = NSAttributedString(string: "Back", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        butDismiss.setAttributedTitle(titleString, for: .normal)
        butDismiss.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        validationView.addSubview(butDismiss)
    }
    
    
    func sendCodeTapped(_ sender: AnyObject) {
        //send phone number to server for sending verification code
        do{
            try inputParser.digitNumberParser(content: txtPhoneNumber.text, length: 10)
            
            initialTimer()
            PFCloud.callFunction(inBackground: "sendCode", withParameters: ["number": txtPhoneNumber.text!]) { (response, error) in
                if(error == nil){
                    self.present(
                        self.alert.showAlertWithOneButton(
                            title: "Success",
                            message: "Message Sent",
                            actionButton: "OK"
                        ),
                        animated: true,
                        completion: nil
                    )
                }else{
                    self.present(
                        self.alert.showAlertWithOneButton(
                            title: "Failed",
                            message: (error?.localizedDescription)!,
                            actionButton: "OK"
                        ),
                        animated: true,
                        completion: nil
                    )
                }
            }
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
                    message: "Phone number is Invalid",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch {
            self.present(
                self.alert.showAlertWithOneButton (
                    title: "Error",
                    message: "Unexpected error",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
            
        }
        
    }
    
    /*Initial the timer*/
    func initialTimer(){
        countLabel.text = "\(sendValidationCodeCountingRange)s"
        countLabel.isHidden = false
        butSendCode.isHidden = true
        sendValidationCodeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ValidationPageViewController.countingDown), userInfo: nil, repeats: true)
    }
    
    /*enable the timer*/
    func countingDown(){
        sendValidationCodeCountingRange = sendValidationCodeCountingRange - 1
        self.butSendCode.setTitle("\(sendValidationCodeCountingRange)s", for:.normal)
        countLabel.text = "\(sendValidationCodeCountingRange)s"
        
        /*If counter reached 0, show the button again*/
        if(sendValidationCodeCountingRange == 0){
            sendValidationCodeTimer.invalidate()
            sendValidationCodeCountingRange = 40
            self.butSendCode.setTitle("Resend Code", for:.normal)
            self.butSendCode.isEnabled = true
            countLabel.isHidden = true
            butSendCode.isHidden = false
        }
    }
    

    
    
    
    func validateTapped(_ sender: AnyObject) {
        do{
            try inputParser.digitNumberParser(content: txtPhoneNumber.text, length: 10)
            try inputParser.digitNumberParser(content: txtValidationCode.text, length: 4)
            
            let params = [
                "number" as NSObject: txtPhoneNumber.text! as AnyObject,
                "code" as NSObject: txtValidationCode.text! as AnyObject
                ] as [NSObject:AnyObject]
            
            PFCloud.callFunction(inBackground: "codeValidation", withParameters: params) { (response, error) in
                if(error == nil){
                    let isValid = response as! Bool
                    if(isValid == true){
                        print("Validation Success")
                        registeredUser = VMWRegisteredUser(usernameInput: self.txtPhoneNumber.text!)
                        let signup : SignupPageNavViewController = self.storyboard?.instantiateViewController(withIdentifier: "signupNav") as! SignupPageNavViewController
                        self.present(signup, animated: true, completion: nil)
                    }else{
                        self.present(
                            self.alert.showAlertWithOneButton(
                                title: "Failed",
                                message: "Validation Failed",
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
                            message: (error?.localizedDescription)!,
                            actionButton: "OK"
                        ),
                        animated: true,
                        completion: nil
                    )
                }
            }
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
        } catch VMWUserDataInputParserError.EmptyValidationCode {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Validation code is Empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWUserDataInputParserError.InvalidDigitNumber {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Validation code is Invalid",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch {
            self.present(
                self.alert.showAlertWithOneButton (
                    title: "Error",
                    message: "Unexpected error",
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
}
