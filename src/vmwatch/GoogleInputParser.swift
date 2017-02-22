//
//  GoogleInputParser.swift
//  vmwatch
//
//  Created by Yanrong Wang on 2017-02-21.
//  Copyright © 2017 ECE496. All rights reserved.
//

import Foundation

internal class GoogleInputParser {
    
    public func privateKeyIDParser(input:String?) throws {
        if(input == nil || input == ""){
            throw GoogleInputParserError.EmptyPrivateKeyID
        }
    }
    
    public func privateKeyParser(input:String?) throws {
        if(input == nil || input == ""){
            throw GoogleInputParserError.EmptyPrivateKey
        }
    }
    
    public func clientIDParser(input:String?) throws {
        if(input == nil || input == ""){
            throw GoogleInputParserError.EmptyClientID
        }
    }
    
    public func projectIDParser(input:String?) throws {
        if(input == nil || input == ""){
            throw GoogleInputParserError.EmptyProjectID
        }
    }
    
    public func instanceIDParser(input:String?) throws {
        if(input == nil || input == ""){
            throw GoogleInputParserError.EmptyInstanceID
        }
    }
    
    public func clientEmailParser(input:String?) throws {
        if(input == nil || input == ""){
            throw GoogleInputParserError.EmptyClientEmail
        }
    }
}

enum GoogleInputParserError: Error{
    case EmptyPrivateKeyID
    case EmptyPrivateKey
    case EmptyClientID
    case EmptyProjectID
    case EmptyInstanceID
    case EmptyClientEmail
    case InvalidAccessCredentialContent
}
