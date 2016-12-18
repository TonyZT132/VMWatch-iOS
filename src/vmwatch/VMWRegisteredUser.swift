//
//  RegisteredUserPack.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-25.
//  Copyright © 2016 ECE496. All rights reserved.
//

import Foundation

internal class VMWRegisteredUser {
    private var username:String?
    private var isRegisred:Bool = false
    private var isLogin:Bool = false
    private var isCanceled:Bool = false
    
    public init (usernameInput:String?){
        self.username = usernameInput
    }
    
    public func setUsername(unsernameInput:String?){
        self.username = unsernameInput
    }
    
    public func getUsername() throws -> String {
        if(self.username != nil){
            return self.username!
        }
        throw VMWRegisteredUserError.InvalidUserInfo
    }
    
    public func setRegisterStatus(status:Bool){
        self.isRegisred = status
    }
    
    public func isRegisted() -> Bool {
        return self.isRegisred
    }
    
    public func setLoginStatus(status:Bool){
        self.isLogin = status
    }
    
    public func isLogined() -> Bool{
        return self.isLogin
    }
    
    public func setCancelStatus(status:Bool){
        self.isCanceled = status
    }
    
    public func isUserCanceled() -> Bool {
        return self.isCanceled
    }
    
    public func clear(){
        self.username = nil
        self.isCanceled = false
        self.isLogin = false
        self.isRegisred = false
    }
}

enum VMWRegisteredUserError: Error {
    case InvalidUserInfo
    case InvalidUserStatus
}
