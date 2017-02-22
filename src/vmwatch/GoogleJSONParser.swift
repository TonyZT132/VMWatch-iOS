//
//  GoogleJSONParser.swift
//  vmwatch
//
//  Created by Yanrong Wang on 2017-02-21.
//  Copyright © 2017 ECE496. All rights reserved.
//

import Foundation

internal class GoogleJSONParser {
    private var data:Any?
    
    public init(inputData:Any?) {
        self.data = inputData
    }
    
    public func printData() throws {
        if let dict = self.data as? NSDictionary {
            print(dict)
        } else {
            throw GoogleJSONParserError.InvalidGoogleJSONDataError
        }
    }
    
    public func setData(inputData:Any?){
        self.data = inputData
    }
    
    public func getCpuArray(type: String) throws -> NSMutableArray {
        do{
            let dataArr = NSMutableArray()
            if let jsonResult = (self.data!) as? [String : Any] {
                if let cpus = jsonResult[type] as? [Any]{
                    for object in cpus {
                        if let inner_result = object as? [String : Any] {
                            var dict = [String:Any]()
                            if let value = inner_result["value"] as? [String : Any]{
                                dict["data"] = value["doubleValue"]
                            }
                            if let time = inner_result["interval"] as? [String : Any]{
                                dict["time"] = time["startTime"]
                            }
                            dataArr.add(dict as NSDictionary)
                        }
                    }
                }
            }
            return dataArr
        }
    }
    
    
    public func getOtherArray(type: String) throws -> NSMutableArray {
        do{
            let dataArr = NSMutableArray()
            if let jsonResult = (self.data!) as? [String : Any] {
                if let cpus = jsonResult[type] as? [Any]{
                    for object in cpus {
                        if let inner_result = object as? [String : Any] {
                            var dict = [String:Any]()
                            if let value = inner_result["value"] as? [String : Int]{
                                dict["data"] = value["int64Value"]
                            }
                            if let time = inner_result["interval"] as? [String : Any]{
                                dict["time"] = time["startTime"]
                            }
                            dataArr.add(dict as NSDictionary)
                        }
                    }
                }
            }
            return dataArr
        }
    }
}

enum GoogleJSONParserError: Error {
    case InvalidGoogleJSONDataError
}
