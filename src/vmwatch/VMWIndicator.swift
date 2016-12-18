//
//  VMWIndicator.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2016-10-06.
//  Copyright © 2016 ECE496. All rights reserved.
//

import Foundation

internal class VMWIndicator {
    
    public func showWithMessage(context:String!){
        displayEZLoadingActivit(context: context)
    }
    
    public func dismiss(){
        dismissEZLoadingActivitWithoutShowStatus()
    }
    
    private func displaySVProgressHUD(){
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
    }
    
    private func dismissSVProgressHUD(){
        SVProgressHUD.dismiss()
    }
    
    private func displayEZLoadingActivit(context:String!){
        EZLoadingActivity.show(context, disableUI: true)
    }
    
    private func dismissEZLoadingActivitWithoutShowStatus(){
        EZLoadingActivity.hide()
    }
    
    private func dismissEZLoadingActivit(status:Bool!, isAnimated:Bool!){
        EZLoadingActivity.hide(status, animated: isAnimated)
    }
}
