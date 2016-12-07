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
    let HEIGHT = UIScreen.main.bounds.height
    let LOGO_SIZE_FACTOR:CGFloat = 1.70454545454545
    var SELECTION_BUTTON_HEIGHT:CGFloat!
    var scrollView: UIScrollView!
    
    var scrollViewHeight:CGFloat = 0
    var buttonArr = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        SELECTION_BUTTON_HEIGHT = WIDTH / LOGO_SIZE_FACTOR
        scrollView = UIScrollView(frame: CGRect(x:0, y:0, width: WIDTH, height: HEIGHT))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.backgroundColor = UIColor.clear.cgColor
        self.view.addSubview(scrollView)
        self.startLoadView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func startLoadView(){
        for i in 0 ... (SERVICE.count - 1) {
            let selectionButton = UIButton(frame: CGRect(x:0, y:scrollViewHeight, width: WIDTH, height: SELECTION_BUTTON_HEIGHT))
            selectionButton.tag = i
            selectionButton.addTarget(self, action: #selector(self.buttonSelected(sender:)), for: .touchUpInside)
            selectionButton.clipsToBounds = true
            let dict = SERVICE[i] as Dictionary
            let logo = UIImage(named: dict["icon"] as! String)
            let logoView = UIImageView(frame: CGRect(x:0, y:0, width: selectionButton.layer.frame.width, height: selectionButton.layer.frame.height))
            logoView.image = logo
            selectionButton.addSubview(logoView)
            scrollView.addSubview(selectionButton)
            buttonArr.add(selectionButton)
            scrollViewHeight += SELECTION_BUTTON_HEIGHT
        }
        scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)
    }
    
    @objc private func buttonSelected (sender: UIButton!) {
        switch sender.tag {
            case 0:
                let ec2Setup : NewEC2WatchTableViewController = EC2View.instantiateViewController(withIdentifier: "ec2setup") as! NewEC2WatchTableViewController
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
}
