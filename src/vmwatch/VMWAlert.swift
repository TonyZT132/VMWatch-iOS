//
//  Alert.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-25.
//  Copyright © 2016 ECE496. All rights reserved.
//

import Foundation
import UIKit

internal class VMWAlertView {
    
    public func showAlertWithOneButton(title:String, message: String, actionButton:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: actionButton, style: UIAlertActionStyle.default ,handler: nil )
        alert.addAction(action)
        return alert
    }
    
    public func showAlertWithTwoButton(title:String,
                                       message: String,
                                       actionButtonOne:String,
                                       actionButtonTwo: String,
                                       handlerOne: @escaping() -> Void,
                                       handlerTwo: @escaping() -> Void)-> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action_reselect = UIAlertAction(title: actionButtonOne, style:UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            handlerOne()
        })
        alert.addAction(action_reselect)
        let action_cancel = UIAlertAction(title: actionButtonTwo, style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            handlerTwo()
        })
        alert.addAction(action_cancel)
        return alert
    }
}



