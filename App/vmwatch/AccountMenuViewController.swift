//
//  AccountMenuViewController.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-10.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class AccountMenuViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor.white.cgColor
        signupButton.layer.cornerRadius = 5
        signupButton.clipsToBounds = true
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(registeredUser != nil && (registeredUser?.isRegisted() == true || registeredUser?.isLogined() == true || registeredUser?.isUserCanceled() == true)){
            registeredUser = nil
            indicator.dismiss()
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doSignup(_ sender: AnyObject) {
        let validation : ValidationPageNavViewController = self.storyboard?.instantiateViewController(withIdentifier: "validationNav") as! ValidationPageNavViewController
        self.present(validation, animated: true, completion: nil)
        
    }
    
    @IBAction func doLogin(_ sender: AnyObject) {
        let login : LoginNavViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginNav") as! LoginNavViewController
        self.present(login, animated: true, completion: nil)
    }
    
    @IBAction func backToInfoPage(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
