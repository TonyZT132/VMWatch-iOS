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
    
    public func printData() throws {
        if let dict = self.data as? NSDictionary {
            print(dict)
        } else {
            throw VMWEC2JSONParserError.InvalidEC2JSONDataError
        }
    }
    
    public func getCPUUtilization() throws -> Double {
        if let dict = self.data as? NSDictionary {
            if let datapointsArray = dict["Datapoints"] as? NSArray {
                if(datapointsArray.count > 0){
                    var cpuValue:Double = 0
                    for i in 0 ..< datapointsArray.count{
                        if let cpuDataObj = datapointsArray[i] as? NSDictionary {
                            cpuValue = cpuValue + (cpuDataObj["Average"]! as AnyObject).doubleValue
                        }
                    }
                    return (cpuValue / Double(datapointsArray.count))
                }
            }
        }
        throw VMWEC2JSONParserError.InvalidEC2JSONDataError
    }
}

enum VMWEC2JSONParserError: Error {
    case InvalidEC2JSONDataError
}
