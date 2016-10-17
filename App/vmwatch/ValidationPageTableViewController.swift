//
//  ValidationPageTableViewController.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-11.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class ValidationPageTableViewController: UITableViewController {
    
    let alert = VMWAlertView()
    let inputParser = VMWInputParser()
    
    @IBOutlet weak var phoneNumberTextView: UITextField!
    @IBOutlet weak var validationCodeTextView: UITextField!
    @IBOutlet weak var getValidationCodeButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var validationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNumberTextView.keyboardType = UIKeyboardType.numberPad
        
        self.countLabel.isHidden = true
        self.countLabel.layer.borderWidth = 1
        self.countLabel.layer.borderColor = UIColor.gray.cgColor
        self.countLabel.textColor = UIColor.gray
        self.countLabel.layer.cornerRadius = 5
        self.countLabel.clipsToBounds = true
        
        self.getValidationCodeButton.setTitleColor(UIColor(red: 31.0/255.0, green: 134.0/255.0, blue: 204.0/255.0, alpha:1.0), for: .normal)
        self.getValidationCodeButton.layer.borderWidth = 1
        self.getValidationCodeButton.layer.borderColor = UIColor(red: 31.0/255.0, green: 134.0/255.0, blue: 204.0/255.0, alpha:1.0).cgColor
        self.getValidationCodeButton.layer.cornerRadius = 5
        self.getValidationCodeButton.clipsToBounds = true
        
        self.validationButton.layer.cornerRadius = 5
        self.validationButton.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(registeredUser != nil && registeredUser?.isRegisted() == true){
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    @IBAction func getValidationCode(_ sender: AnyObject) {
        do{
            try inputParser.digitNumberParser(content: phoneNumberTextView.text, length: 10)
            
            initialTimer()
            PFCloud.callFunction(inBackground: "sendCode", withParameters: ["number": phoneNumberTextView.text!]) { (response, error) in
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
        } catch VMWInputParserError.EmptyPhoneNumber {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Phone number is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWInputParserError.InvalidDigitNumber {
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
        getValidationCodeButton.isHidden = true
        sendValidationCodeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ValidationPageTableViewController.countingDown), userInfo: nil, repeats: true)
    }
    
    /*enable the timer*/
    func countingDown(){
        sendValidationCodeCountingRange = sendValidationCodeCountingRange - 1
        self.getValidationCodeButton.setTitle("\(sendValidationCodeCountingRange)s", for:.normal)
        countLabel.text = "\(sendValidationCodeCountingRange)s"
        
        /*If counter reached 0, show the button again*/
        if(sendValidationCodeCountingRange == 0){
            sendValidationCodeTimer.invalidate()
            sendValidationCodeCountingRange = 40
            self.getValidationCodeButton.setTitle("Resend Code", for:.normal)
            self.getValidationCodeButton.isEnabled = true
            countLabel.isHidden = true
            getValidationCodeButton.isHidden = false
        }
    }
    
    @IBAction func doValidation(_ sender: AnyObject) {
        do{
            try inputParser.digitNumberParser(content: phoneNumberTextView.text, length: 10)
            try inputParser.digitNumberParser(content: validationCodeTextView.text, length: 4)
            
            let params = [
                "number" as NSObject: phoneNumberTextView.text! as AnyObject,
                "code" as NSObject: validationCodeTextView.text! as AnyObject
            ] as [NSObject:AnyObject]
            
            PFCloud.callFunction(inBackground: "codeValidation", withParameters: params) { (response, error) in
                if(error == nil){
                    let isValid = response as! Bool
                    if(isValid == true){
                        print("Validation Success")
                        registeredUser = VMWRegisteredUser(usernameInput: self.phoneNumberTextView.text!)
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
        } catch VMWInputParserError.EmptyPhoneNumber {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Phone number is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWInputParserError.EmptyValidationCode {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Validation code is Empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWInputParserError.InvalidDigitNumber {
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

    @IBAction func dismissPage(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
