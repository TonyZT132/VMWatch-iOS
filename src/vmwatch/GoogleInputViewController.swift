//
//  GoogleInputViewController.swift
//  vmwatch
//
//  Created by Yanrong Wang on 2017-03-09.
//  Copyright © 2017 ECE496. All rights reserved.
//

//
//  LoginViewController.swift
//  vmwatch
//
//  Created by Yanrong Wang on 2017-03-08.
//  Copyright © 2017 ECE496. All rights reserved.

import UIKit

public class GoogleInputViewController: UIViewController {
    
    // MARK: - Variables
    var txtPrivateKeyID: UITextField!
    var txtPrivateKey: UITextField!
    var txtClientID: UITextField!
    var txtClientEmail: UITextField!
    var txtProjectID: UITextField!
    var txtInstanceID: UITextField!
    var logoView: UIImageView!
    
    var butSubmit: UIButton!
    var butDismiss: UIButton!
    /*variable for storing google credentials*/
    var google_credentials: [String: String]!
    var google_history_credentials: NSMutableArray!

    let parser = GoogleInputParser()
    let alert = VMWAlertView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.set_view()
        //hide keyboard when tapped around
        self.hideKeyboardWhenTappedAround()
        //move view up/down when keyboard is shown/hidden
        NotificationCenter.default.addObserver(self, selector: #selector(GooglekeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GooglekeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        self.navigationController?.navigationBar.clipsToBounds = true
        let imageView   = UIImageView(frame: self.view.bounds);
        imageView.image = UIImage(named: "background")!
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        setupLogo()
        let top_y:CGFloat = logoView.frame.maxY + 20;
        txtPrivateKeyID = setInputTxtField(y: top_y+20,txt: "Private Key ID")
        txtPrivateKey = setInputTxtField(y: txtPrivateKeyID.frame.maxY+10,txt: "Private Key")
        txtClientID = setInputTxtField(y: txtPrivateKey.frame.maxY+10,txt: "Client ID")
        txtClientEmail = setInputTxtField(y: txtClientID.frame.maxY+10,txt: "Client Email")
        txtProjectID = setInputTxtField(y: txtClientEmail.frame.maxY+10,txt: "Project ID")
        txtInstanceID = setInputTxtField(y: txtProjectID.frame.maxY+10,txt: "Instance ID")
        setupSubmitButton()
        setupDismissButton()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupLogo() {
        let logo = UIImage(named: "google-logo")
        logoView = UIImageView(frame: CGRect(x: view.bounds.width*0.1, y: view.bounds.height*0.1, width: view.bounds.width*0.8, height: view.bounds.height*0.2))
        logoView.image = logo
        logoView.contentMode = UIViewContentMode.scaleAspectFit
        view.addSubview(logoView)
    }

    func setInputTxtField (y: CGFloat,txt: String) -> UITextField{
        let x: CGFloat = self.view.bounds.width * 0.05
        let width: CGFloat = self.view.bounds.width * 0.9
        let txtField = UITextField(frame: CGRect(x: x, y: y, width: width, height: 30))
        txtField.returnKeyType = .next
        txtField.textColor = UIColor.white
        txtField.attributedPlaceholder = NSAttributedString(string: txt, attributes: [NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        view.addSubview(txtField)
        //add buttom boarder for text field
        let bottomTxtFieldView = UIView(frame: CGRect(x: txtField.frame.minX, y: txtField.frame.maxY + 3, width: width, height: 1))
        bottomTxtFieldView.backgroundColor = .white
        bottomTxtFieldView.alpha = 0.5
        view.addSubview(bottomTxtFieldView)
        return txtField
    }
    func setupSubmitButton() {
        butSubmit = UIButton(frame: CGRect(x: self.view.bounds.width * 0.05, y: txtInstanceID.frame.maxY + 30, width: self.view.bounds.width * 0.9, height: 40))
        butSubmit.backgroundColor = UIColor(red: 1 / 255, green: 61 / 255, blue: 123 / 255, alpha: 0.8)
        butSubmit.setTitle("Submit", for: .normal)
        butSubmit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        butSubmit.layer.cornerRadius = butSubmit.frame.height * 0.5
        butSubmit.layer.borderWidth = 1
        butSubmit.layer.borderColor = UIColor.clear.cgColor
        view.addSubview(butSubmit)
    }
    func setupDismissButton(){
        butDismiss = UIButton(frame: CGRect(x: self.view.bounds.width * 0.05, y: butSubmit.frame.maxY, width: butSubmit.frame.width, height: 40))
        let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        let titleString = NSAttributedString(string: "Back", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        butDismiss.setAttributedTitle(titleString, for: .normal)
        butDismiss.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        view.addSubview(butDismiss)

    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func storeGoogleHistory(){
        let history = GoogleHistoryStorage()
        do{
            try history.deleteHistoryRecord(privateKeyID: self.txtPrivateKeyID.text!, privateKey: self.txtPrivateKey.text! , clientID: self.txtClientID.text!, clientEmail: self.txtClientEmail.text!, projectID: self.txtProjectID.text!, instanceID: self.txtInstanceID.text!)
            try history.storeGoogleHistory(privateKeyID: self.txtPrivateKeyID.text!, privateKey: self.txtPrivateKey.text! , clientID: self.txtClientID.text!, clientEmail: self.txtClientEmail.text!, projectID: self.txtProjectID.text!, instanceID: self.txtInstanceID.text!)
        } catch GoogleCoreDataStorageError.DatabaseStoreError {
            NSLog("Could not save the history data due to database issue")
        } catch GoogleCoreDataStorageError.DatabaseDeleteError {
            NSLog("Fail to remove previous history data due to database issue")
        } catch {
            NSLog("Unexpected database issue")
        }
    }
    
    func getGoogleHistory(){
        let history = GoogleHistoryStorage()
        do{
            try google_history_credentials = history.getGoogleHistory()
        } catch GoogleCoreDataStorageError.DatabaseFetchError {
            NSLog("Could not get the history data due to database issue")
        } catch {
            NSLog("Unexpected database issue")
        }
        
    }
    
    func submitTapped(_ sender: AnyObject) {
        do{
            let parser = GoogleInputParser()
            try parser.privateKeyIDParser(input:txtPrivateKeyID.text)
            try parser.privateKeyParser(input: txtPrivateKey.text)
            try parser.projectIDParser(input: txtProjectID.text)
            try parser.clientIDParser(input: txtClientID.text)
            try parser.clientEmailParser(input: txtClientEmail.text)
            try parser.instanceIDParser(input: txtInstanceID.text)
            
            
            PFCloud.callFunction(inBackground: "GoogleWatch", withParameters: ["privatekeyid" : txtPrivateKeyID.text!, "privatekey" : txtPrivateKey.text!, "clientid" : txtClientID.text!, "clientemail" : txtClientEmail.text!, "instanceid" : txtInstanceID.text!, "projectid" : txtProjectID.text!]){ (response, error) in
                if(error == nil){
                    /*if can successfully access gcc, store credentials in core data*/
                    self.storeGoogleHistory()
                    let GoogleResult : GoogleResultViewController = GoogleView.instantiateViewController(withIdentifier: "GoogleResult") as! GoogleResultViewController
                    GoogleResult.hidesBottomBarWhenPushed = true
                    self.navigationController!.navigationBar.tintColor = UIColor.white
                    self.navigationController?.pushViewController(GoogleResult, animated: true)
                    
                    GoogleResult.response = response
                    
                }else{
                    /* authentication failed no info recieved, error msg*/
                    self.present(
                        self.alert.showAlertWithOneButton(
                            title: "Error",
                            message: "Invalid Access Credentials",
                            actionButton: "OK"
                        ),
                        animated: true,
                        completion: nil
                    )
                }
                
            }
            
        } catch GoogleInputParserError.EmptyPrivateKeyID {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Private Key ID is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch GoogleInputParserError.EmptyPrivateKey{
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Private Key is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }catch GoogleInputParserError.EmptyProjectID{
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Project ID is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }catch GoogleInputParserError.EmptyClientID{
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Client ID is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }catch GoogleInputParserError.EmptyClientEmail{
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Client email is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }catch GoogleInputParserError.EmptyInstanceID{
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Instance ID is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }catch let error as NSError {
            NSLog("Error with request: \(error)")
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
    func GooglekeyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= logoView.frame.maxY
            }
        }
        
    }
    
    func GooglekeyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += logoView.frame.maxY
            }
        }
    }

    
}



