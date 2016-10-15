//
//  VMWInputParser.swift
//  VMWatch
//
//  Created by Tuo Zhang on 2016-09-25.
//  Copyright © 2016 ECE496. All rights reserved.
//

import Foundation

internal class VMWInputParser{
    
    public init() {
        print("New input parser initialized")
    }
    
    public func digitNumberParser(content:String?, length:Int) throws {
        if(content == nil || content == ""){
            if(length == 10){
                throw VMWInputParserError.EmptyPhoneNumber
            }else{
                throw VMWInputParserError.EmptyValidationCode
            }
        }
        
        let Pattern = "^\\d{\(length)}$"
        let matcher = VMWRegex(Pattern)
        if(matcher.match(input: content!) == false){
            throw VMWInputParserError.InvalidDigitNumber
        }
    }
    
    public func nickNameInputParser(nickname:String?) throws {
        if(nickname == nil || nickname == ""){
            throw VMWInputParserError.EmptyNickname
        }
        
        /*setup the nickname*/
        let nicknameNSString = nickname! as NSString
        let nicknameLength = nicknameNSString.length
        
        /*Check the length of the nickname*/
        if(nicknameLength < 1 || nicknameLength > 20){
            throw VMWInputParserError.InvalidNicknameLength
        }
    }
    
    public func passwordParser(password:String?, retypedPassword:String?) throws {
        if(password == nil || password == "" || retypedPassword == nil || retypedPassword == ""){
            throw VMWInputParserError.EmptyPasswordInput
        }

        /*setup the password*/
        let passwordNSString = password! as NSString
        let passwordNSStringLength = passwordNSString.length
        
        /*check the password length*/
        if(passwordNSStringLength < 7 || passwordNSStringLength > 18){
            throw VMWInputParserError.InvalidPasswordLength
        }
        
        /*check password is match or not*/
        if(password! != retypedPassword!){
            throw VMWInputParserError.PasswordDidNotMatch
        }
    }
}

private class VMWRegex {
    private let regex: NSRegularExpression?
    
    public init(_ pattern: String) {
        regex = try? NSRegularExpression(
            pattern: pattern,
            options: .caseInsensitive
        )
    }
    
    public func match(input: String) -> Bool {
        if let matches = regex?.matches(
            in: input,
            options: [],
            range: NSMakeRange(0, (input as NSString).length)
            ){
            return matches.count > 0
        } else {
            return false
        }
    }
}

enum VMWInputParserError: Error {
    case EmptyPhoneNumber
    case EmptyValidationCode
    case InvalidDigitNumber
    case EmptyNickname
    case InvalidNicknameLength
    case EmptyPasswordInput
    case InvalidPasswordLength
    case PasswordDidNotMatch
}
