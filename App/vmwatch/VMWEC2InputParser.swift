//
//  VMWEC2InputParser.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2016-12-09.
//  Copyright © 2016 ECE496. All rights reserved.
//

import Foundation

internal class VMWEC2InputParser {
    
    public func accessIDParser(input:String?) throws {
        if(input == nil || input == ""){
            throw VMWEC2InputParserError.EmptyAccessKey
        }
    }
    
    public func secretKeyParser(input:String?) throws {
        if(input == nil || input == ""){
            throw VMWEC2InputParserError.EmptySecretKey
        }
    }
    
    public func instanceIDParser(input:String?) throws {
        if(input == nil || input == ""){
            throw VMWEC2InputParserError.EmptyInstanceID
        }
    }
    
    public func regionParser(input:String?) throws {
        if(input == nil || input == ""){
            throw VMWEC2InputParserError.EmptyRegion
        }
    }
}

enum VMWEC2InputParserError: Error{
    case EmptyAccessKey
    case EmptySecretKey
    case EmptyInstanceID
    case EmptyRegion
    case InvalidAccessCredentialContent
}
