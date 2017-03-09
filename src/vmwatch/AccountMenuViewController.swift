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
    
    var logoImg: UIImageView!
    var logoBlur: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor(red: 1 / 255, green: 61 / 255, blue: 123 / 255, alpha: 0.8).cgColor
        signupButton.layer.backgroundColor = UIColor(red: 1 / 255, green: 61 / 255, blue: 123 / 255, alpha: 0.8).cgColor
        signupButton.layer.cornerRadius = signupButton.frame.size.height / 2
        signupButton.clipsToBounds = true
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(red: 1 / 255, green: 61 / 255, blue: 123 / 255, alpha: 0.8).cgColor
        loginButton.layer.backgroundColor = UIColor(red: 1 / 255, green: 61 / 255, blue: 123 / 255, alpha: 0.8).cgColor
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2 
        loginButton.clipsToBounds = true
        
        let imageView   = UIImageView(frame: self.view.bounds);
        imageView.image = UIImage(named: "background")!
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        setupLoginLogo()
        
        
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
    
    
    @IBAction func doSignup(_ sender: AnyObject) {
        let validation : ValidationPageNavViewController = self.storyboard?.instantiateViewController(withIdentifier: "validationNav") as! ValidationPageNavViewController
        self.present(validation, animated: true, completion: nil)
        
    }
    
    @IBAction func doLogin(_ sender: AnyObject) {
        let login : LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") as! LoginViewController
        
        //login.hidesBottomBarWhenPushed = true
        //self.navigationController!.navigationBar.tintColor = UIColor.white
        //self.navigationController?.pushViewController(login, animated: true)
 
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
