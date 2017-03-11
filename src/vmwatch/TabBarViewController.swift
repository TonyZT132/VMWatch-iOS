//
//  TabBarViewController.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-08.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class TabBarViewController: CYLTabBarController {
    
    let tabTitle = ["Home","New","Info"]
    let selectedImage = ["home_selected","new_selected","info_selected"]
    let image = ["home","new","info"]

    override func viewDidLoad() {
        super.viewDidLoad()
        /*Initialize Storyboard*/
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        /*Set up View Controllers*/
        let new : NewPageNavViewController = storyboard.instantiateViewController(withIdentifier: "newNav") as! NewPageNavViewController
        let info : InfoPageNavViewController = storyboard.instantiateViewController(withIdentifier: "infoNav") as! InfoPageNavViewController
        let home : HomePageNavViewController = storyboard.instantiateViewController(withIdentifier: "homeNav") as! HomePageNavViewController
        
        /*Create Tab Bar Items Array*/
        var tabBarItemsAttributes: [[AnyHashable:Any]] = []
        let viewControllers:[UIViewController] = [home,new,info]
        
        for i in 0 ..< tabTitle.count {
            let dict: [NSObject : AnyObject] = [
                CYLTabBarItemTitle as NSObject: tabTitle[i] as AnyObject,
                CYLTabBarItemImage as NSObject: image[i] as AnyObject,
                CYLTabBarItemSelectedImage as NSObject: selectedImage[i] as AnyObject
            ]
            
            tabBarItemsAttributes.append(dict)
        }
        self.tabBarItemsAttributes = tabBarItemsAttributes
        self.viewControllers = viewControllers
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
