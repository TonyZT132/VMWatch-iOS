//
//  NewPageViewController.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-08.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class NewPageViewController: UIViewController {
    
    let alert = VMWAlertView()
    
    let WIDTH = UIScreen.main.bounds.width
    let SELECTION_BUTTON_HEIGHT:CGFloat = 140
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrollViewHeight:CGFloat = 10
    var buttonArr = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.layer.backgroundColor = UIColor.clear.cgColor
        self.startLoadView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func startLoadView(){
        for i in 0 ... (SERVICE.count - 1) {
            let selectionButton = UIButton(frame: CGRect(x:20, y:scrollViewHeight, width: WIDTH - 40, height: SELECTION_BUTTON_HEIGHT))
            selectionButton.tag = i
            selectionButton.addTarget(self, action: #selector(self.buttonSelected(sender:)), for: .touchUpInside)
            selectionButton.layer.borderWidth = 2
            selectionButton.layer.borderColor = UIColor(red: 31.0/255.0, green: 134.0/255.0, blue: 204.0/255.0, alpha:1.0).cgColor
            selectionButton.layer.cornerRadius = 5
            selectionButton.clipsToBounds = true
            let dict = SERVICE[i] as Dictionary
            let logo = UIImage(named: dict["icon"] as! String)
            let logoView = UIImageView(frame: CGRect(x:0, y:0, width: selectionButton.layer.frame.width, height: selectionButton.layer.frame.height))
            logoView.image = logo
            selectionButton.addSubview(logoView)
            scrollView.addSubview(selectionButton)
            buttonArr.add(selectionButton)
            scrollViewHeight += SELECTION_BUTTON_HEIGHT + 10
        }
        scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)
    }
    
    @objc private func buttonSelected (sender: UIButton!) {
        switch sender.tag {
            case 0:
                let ec2Setup : NewEC2WatchTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "ec2setup") as! NewEC2WatchTableViewController
                ec2Setup.hidesBottomBarWhenPushed = true
                self.navigationController!.navigationBar.tintColor = UIColor.white
                self.navigationController?.pushViewController(ec2Setup, animated: true)
            default:
                self.present(
                    self.alert.showAlertWithOneButton(
                        title: "Opps",
                        message: "This service is not avaliable yet",
                        actionButton: "OK"
                    ),
                    animated: true,
                    completion: nil
                )
        }
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
