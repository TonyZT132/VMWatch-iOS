//
//  LoginTableViewController.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-10.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController{

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let inputParser = VMWInputParser()
    let alert = VMWAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNumberTextField.keyboardType = UIKeyboardType.phonePad
        
        self.loginButton.layer.cornerRadius = 5
        self.loginButton.clipsToBounds = true
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
    
    @IBAction func doLogin(_ sender: AnyObject) {
        do{
            try inputParser.digitNumberParser(content: phoneNumberTextField.text, length: 10)
            if(passwordTextField.text == nil || passwordTextField.text == ""){
                throw VMWInputParserError.EmptyPasswordInput
            }
            
            indicator.showWithMessage(context: "Logging")
            PFUser.logInWithUsername(inBackground: phoneNumberTextField.text!, password: passwordTextField.text!, block: { (loggedUser, loggingError) in
                if(loggingError == nil){
                    registeredUser = VMWRegisteredUser(usernameInput: self.phoneNumberTextField.text!)
                    registeredUser?.setLoginStatus(status: true)
                    /*set up loading screen*/
                    self.dismiss(animated: true, completion: nil)
                }else{
                    indicator.dismiss()
                    self.present(
                        self.alert.showAlertWithOneButton(
                            title: "Error",
                            message: loggingError.debugDescription,
                            actionButton: "OK"
                        ),
                        animated: true,
                        completion: nil
                    )
                }
            })
        } catch VMWInputParserError.InvalidDigitNumber {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Phone number is empty or invalid",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch VMWInputParserError.EmptyPasswordInput {
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
    
    @IBAction func dismissPage(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
