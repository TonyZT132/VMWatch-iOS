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
    
    public func setData(inputData:Any?){
        self.data = inputData
    }
    
    public func getAverageData(category:String) throws -> Double {
        if let dict = self.data as? NSDictionary {
            if let datapointsArray = dict["Datapoints"] as? NSArray {
                if(datapointsArray.count > 0){
                    var dataValue:Double = 0
                    for i in 0 ..< datapointsArray.count{
                        if let dataObj = datapointsArray[i] as? NSDictionary {
                            dataValue = dataValue + (dataObj[category]! as AnyObject).doubleValue
                        }
                    }
                    return (dataValue / Double(datapointsArray.count))
                }
            }
        }
        throw VMWEC2JSONParserError.InvalidEC2JSONDataError
    }
    
    public func getDataPointsArray(category:String) throws -> NSMutableArray {
        let dataArr = NSMutableArray()
        if let dict = self.data as? NSDictionary {
            if let datapointsArray = dict["Datapoints"] as? NSArray {
                if(datapointsArray.count > 0){
                    for i in 0 ..< datapointsArray.count {
                        if let dataObj = datapointsArray[i] as? NSDictionary {
                            var dict = [String:AnyObject]()
                            dict["data"] = dataObj[category]! as AnyObject
                            dict["time"] = dataObj["Timestamp"]! as AnyObject
                            dataArr.add(dict as NSDictionary)
                        } else {
                            throw VMWEC2JSONParserError.InvalidEC2JSONDataError
                        }
                    }
                    return dataArr
                }
            }
        }
        throw VMWEC2JSONParserError.InvalidEC2JSONDataError
    }
}

enum VMWEC2JSONParserError: Error {
    case InvalidEC2JSONDataError
}
