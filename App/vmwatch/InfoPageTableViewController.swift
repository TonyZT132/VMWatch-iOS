//
//  InfoPageTableViewController.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-10.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class InfoPageTableViewController: UITableViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var logoutButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.cornerRadius = 5
        logoutButton.clipsToBounds = true
        
        profileImage.layer.cornerRadius = 35
        profileImage.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(PFUser.current() == nil){
            logoutButtonView.isHidden = true
            self.accountNameLabel.text = "Account Name"
            self.profileImage.image = UIImage(named: "non_user")
        }else{
            logoutButtonView.isHidden = false
            self.accountNameLabel.text = PFUser.current()?.object(forKey: "nickname") as? String
            let userImageFile = PFUser.current()!.object(forKey: "profileImage")  as! PFFile
            userImageFile.getDataInBackground(block: { (imageData, error) in
                if(error == nil){
                    if (imageData != nil) {
                        self.profileImage.image = UIImage(data:imageData!)
                    }
                }else{
                    self.profileImage.image = UIImage(named: "non_user")
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return 1
            default:
                return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                if(PFUser.current() == nil){
                    let accountMenu : AccountMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "accountMenu") as! AccountMenuViewController
                    self.present(accountMenu, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func doLogout(_ sender: AnyObject) {
        PFUser.logOut()
        logoutButtonView.isHidden = true
        let accountMenu : AccountMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "accountMenu") as! AccountMenuViewController
        self.present(accountMenu, animated: true, completion: nil)
    }

}
