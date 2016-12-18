//
//  InfoPageTableViewController.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-10.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class InfoPageTableViewController: UITableViewController, RSKImageCropViewControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var logoutButtonView: UIView!
    let alert = VMWAlertView()
    var croppedImage: UIImage!
    
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
                }else{
                    /*Setup alert for photo selection type menu (take photo or choose existing photo)*/
                    let optionMenu = UIAlertController(title: nil, message: "Update profile image", preferredStyle: .actionSheet)
                    
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
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                        (alert: UIAlertAction!) -> Void in })
                    
                    /*Add all actions*/
                    optionMenu.addAction(photoPickAction)
                    optionMenu.addAction(cancelAction)
                    self.present(optionMenu, animated: true, completion: nil)
                }
            }
        } else if(indexPath.section == 1){
            if(indexPath.row == 0){
                self.present(
                    alert.showAlertWithTwoButton(
                        title: "Notice",
                        message: "Do you want to clear the database?",
                        actionButtonOne: "Yes",
                        actionButtonTwo: "No",
                        handlerOne: {() -> Void in
                            do{
                                try VMWEC2HistoryStorage().clearHistory()
                                self.present(
                                    self.alert.showAlertWithOneButton(
                                        title: "Success",
                                        message: "Data cleared",
                                        actionButton: "OK"
                                    ),
                                    animated: true,
                                    completion: nil
                                )
                            } catch {
                                NSLog("Error ocuured when clear the database")
                            }
                        },
                        handlerTwo: {() -> Void in
                            return
                    }
                    ),
                    animated: true,
                    completion: nil
                )
            }
        }
    }
    
    @IBAction func doLogout(_ sender: AnyObject) {
        self.present(
            alert.showAlertWithTwoButton(
                title: "Notice",
                message: "Do you want to log out?",
                actionButtonOne: "Yes",
                actionButtonTwo: "No",
                handlerOne: {() -> Void in
                    PFUser.logOut()
                    self.logoutButtonView.isHidden = true
                    let accountMenu : AccountMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "accountMenu") as! AccountMenuViewController
                    self.present(accountMenu, animated: true, completion: nil)
                },
                handlerTwo: {() -> Void in
                    return
                }
            ),
            animated: true,
            completion: nil
        )
    }
    
    private func pictureUpdate(){
        /*Do update*/
        if let currentUser = PFUser.current(){
            
            /*Resize the image*/
            let imageData = UIImageJPEGRepresentation(self.croppedImage, 0.2)
            let imageFile = PFFile (data:imageData!)
            currentUser["profileImage"] = imageFile
            currentUser.saveInBackground(block: { (success, error) -> Void in
                indicator.dismiss()
                if(error == nil){
                    self.profileImage.image = UIImage(data:imageData!)
                }else{
                    self.present(
                        self.alert.showAlertWithOneButton(
                            title: "Error",
                            message: "Fail to update the profile picture",
                            actionButton: "OK"
                        ),
                        animated: true,
                        completion: nil
                    )
                }
            })
        }else{
            indicator.dismiss()
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Fail to update the profile picture",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }
    }
    
    //MARK: Image cropper delegate
    
    /*Get the cropped image*/
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.croppedImage = croppedImage
        self.navigationController?.dismiss(animated: true, completion: nil)
        indicator.showWithMessage(context: "Updating")
        self.pictureUpdate()
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        return
    }
}
