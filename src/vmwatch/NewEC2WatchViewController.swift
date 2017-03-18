//
//  NewEC2WatchViewController.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2017-03-17.
//  Copyright © 2017 ECE496. All rights reserved.
//

import UIKit

class NewEC2WatchViewController: UIViewController {
    
    let WIDTH = UIScreen.main.bounds.width
    let HEIGHT = UIScreen.main.bounds.height
    var scrollView: UIScrollView!
    
    var scrollViewHeight:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.setScrollView()
        self.setLogoView()
        self.setInputList()

        scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setScrollView(){
        let NavBarYPosition:CGFloat = self.navigationController!.navigationBar.frame.maxY;
        let TabBarYPosition:CGFloat = self.tabBarController!.tabBar.frame.minY;
        
        scrollView = UIScrollView(frame: CGRect(x:0, y: NavBarYPosition, width: WIDTH, height: HEIGHT - NavBarYPosition - (HEIGHT - TabBarYPosition)))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.backgroundColor = UIColor.clear.cgColor
        self.view.addSubview(scrollView)
    }
    
    private func setLogoView(){
        let logo = UIImage(named: "aws-logo")
        let logoView = UIImageView(frame: CGRect(x: view.bounds.width * 0.1, y: 30, width: view.bounds.width * 0.8, height: view.bounds.height * 0.2))
        logoView.image = logo
        logoView.contentMode = UIViewContentMode.scaleAspectFit
        scrollView.addSubview(logoView)
        scrollViewHeight += 30 + logoView.frame.height
    }
    
    private func setInputList(){
        
        let txtAccessID = setInputTxtField(y: scrollViewHeight + 20,txt: "Access ID")
        scrollView.addSubview(txtAccessID)
        scrollViewHeight += 20 + txtAccessID.frame.height
        
        let txtAccessKey = setInputTxtField(y: scrollViewHeight + 20,txt: "Access Key")
        scrollView.addSubview(txtAccessKey)
        scrollViewHeight += 20 + txtAccessKey.frame.height
        
        let txtInstanceID = setInputTxtField(y: scrollViewHeight + 20,txt: "Instance ID")
        scrollView.addSubview(txtInstanceID)
        scrollViewHeight += 20 + txtInstanceID.frame.height
    }
    
    func setInputTxtField (y: CGFloat,txt: String) -> UITextField {
        let x: CGFloat = self.view.bounds.width * 0.05
        let width: CGFloat = self.view.bounds.width * 0.9
        
        let txtField = UITextField(frame: CGRect(x: x, y: y, width: width, height: 30))
        txtField.returnKeyType = .next
        txtField.textColor = UIColor.white
        txtField.attributedPlaceholder = NSAttributedString(string: txt, attributes: [NSForegroundColorAttributeName: UIColor(red: 196, green: 195, blue: 212, alpha: 1)])
        
        let border = CALayer()
        let widthBoarder = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: txtField.frame.size.height - widthBoarder, width:  txtField.frame.size.width, height: txtField.frame.size.height)
        
        border.borderWidth = widthBoarder
        txtField.layer.addSublayer(border)
        txtField.layer.masksToBounds = true
        
        return txtField
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
