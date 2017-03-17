//
//  HomePageViewController.swift
//  vmwatch
//
//  Created by Yuxuan Zhang on 2017-03-10.
//  Copyright © 2017 ECE496. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    let alert = VMWAlertView()
    
    let WIDTH = UIScreen.main.bounds.width
    let HEIGHT = UIScreen.main.bounds.height
    var scrollView: UIScrollView!
    
    var scrollViewHeight:CGFloat = 0
    
    let TOP_SPACE:CGFloat! = 25
    let SPACE:CGFloat! = 5
    let TITLE_VIEW_HEIGHT:CGFloat! = 20
    let VM_ITEM_VIEW_HEIGHT:CGFloat! = 70

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setScrollView()
        self.setTitleView()
        self.getLocalVMList()
        
        scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)
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
    
    private func setTitleView(){
        scrollViewHeight += TOP_SPACE
        let title = UILabel(frame: CGRect(x: 25, y: scrollViewHeight, width: WIDTH - 50, height: 20) )
        title.text = " Recently Visited"
        title.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        title.font = title.font.withSize(12)
        title.textColor = .white
        scrollView.addSubview(title)
        scrollViewHeight += TITLE_VIEW_HEIGHT
    }
    
    private func getLocalVMList(){
        for i in 0 ... 10{
            scrollViewHeight += SPACE
            let VMItem = UIView(frame: CGRect(x: 25, y: scrollViewHeight, width: WIDTH - 50, height: VM_ITEM_VIEW_HEIGHT))
            VMItem.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
            
            let ICON_VIEW_SIZE = 60
            let iconView = UIImageView(frame: CGRect(x: 5, y: 5, width: ICON_VIEW_SIZE, height: ICON_VIEW_SIZE))
            iconView.image = UIImage(named: "icon")!
            iconView.layer.cornerRadius = iconView.frame.height / 2
            iconView.clipsToBounds = true
            VMItem.addSubview(iconView)
            
            let ARROW_VIEW_SIZE = 30
            let arrowView = UIView(frame: CGRect(x: Int(VMItem.frame.width - CGFloat(50)), y: 20, width: ARROW_VIEW_SIZE, height: ARROW_VIEW_SIZE))
            arrowView.backgroundColor = UIColor.clear
            arrowView.layer.cornerRadius = arrowView.frame.height / 2
            arrowView.clipsToBounds = true
            
            let arrowImage = UIImageView(frame: CGRect(x: 0, y: 0, width: arrowView.frame.width, height: arrowView.frame.height))
            arrowImage.image = UIImage(named: "arrow")!
            arrowImage.layer.cornerRadius = arrowImage.frame.height / 2
            arrowImage.clipsToBounds = true
            arrowView.addSubview(arrowImage)
            
            VMItem.addSubview(arrowView)

            let instanceIDView = UILabel(frame: CGRect(x: 5 + iconView.frame.width + 5, y: 10, width: VMItem.frame.width - iconView.frame.width - arrowView.frame.width - 40, height: 20) )
            instanceIDView.text = " Instance ID: i-80774934729"
            instanceIDView.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
            instanceIDView.font = instanceIDView.font.withSize(12)
            instanceIDView.textColor = .white
            VMItem.addSubview(instanceIDView)
            
            let dateView = UILabel(frame: CGRect(x: 5 + iconView.frame.width + 5, y: 10 + instanceIDView.frame.height + 5, width: VMItem.frame.width - iconView.frame.width - arrowView.frame.width - 40, height: 20) )
            dateView.text = " 2017-01-18 16:30"
            dateView.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
            dateView.font = instanceIDView.font.withSize(12)
            dateView.textColor = .white
            VMItem.addSubview(dateView)
            
            scrollView.addSubview(VMItem)
            scrollViewHeight += VM_ITEM_VIEW_HEIGHT
        }
    }
}
