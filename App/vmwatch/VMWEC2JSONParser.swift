//
//  VMWJSONParser.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2016-10-16.
//  Copyright © 2016 ECE496. All rights reserved.
//

import Foundation

internal class VMWEC2JSONParser {
    var data:Any?
    
    public init(inputData:Any?){
        self.data = inputData
    }
    
    public func getCPUUtilization() throws -> Double {
        if let dict = self.data as? NSDictionary {
            if let datapointsArray = dict["Datapoints"] as? NSArray{
                if let cpuData = datapointsArray[0] as? NSDictionary{
                    return (cpuData["Average"]! as AnyObject).doubleValue
                }
            }
        }
        throw VMWEC2JSONParserError.InvalidEC2JSONDataError
    }
}

enum VMWEC2JSONParserError: Error {
    case InvalidEC2JSONDataError
}
