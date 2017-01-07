//
//  ServiceJSONParser.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2017-01-07.
//  Copyright © 2017 ECE496. All rights reserved.
//

import Foundation

internal class VMWServiceJSONParser {
    private var data:Any?
    
    public init(inputData:Any?) {
        self.data = inputData
    }
    
    public func parse() throws -> [NSDictionary] {
        if(self.data != nil){
            if let jsonDict = self.data as? NSDictionary {
                if let serviceArray = jsonDict["service"] as? NSArray {
                    if(serviceArray.count > 0){
                        var result = [NSDictionary]()
                        for i in 0 ..< serviceArray.count{
                            if let dataObj = serviceArray[i] as? NSDictionary {
                                var dict = [String : AnyObject]()
                                let serviceId = dataObj["id"] as! Int
                                let serviceName = dataObj["name"] as! String
                                let serviceIcon = dataObj["icon"] as! String
                                let serviceAvaliability = dataObj["avaliable"] as! Bool
                                
                                dict["id"] = serviceId as AnyObject?
                                dict["name"] = serviceName as AnyObject?
                                dict["icon"] = serviceIcon as AnyObject?
                                dict["avaliable"] = serviceAvaliability as AnyObject?
                                
                                let nsdict = dict as NSDictionary
                                result.append(nsdict)
                            }else{
                                throw VMWServiceJSONParserError.InvalidServiceJSONDataError
                            }
                        }
                        return result
                    }
                }
            }
        }
        throw VMWServiceJSONParserError.InvalidServiceJSONDataError
    }
}

enum VMWServiceJSONParserError: Error {
    case InvalidServiceJSONDataError
}
