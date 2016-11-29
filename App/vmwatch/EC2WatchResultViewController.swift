//
//  EC2WatchResultViewController.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2016-10-16.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class EC2WatchResultViewController: UIViewController {
    
    var region:String?
    var accessID:String?
    var accessKey:String?
    var instanceID:String?
    let alert = VMWAlertView()

    var cpuUtilizationData:Double!
    var networkInData = NSMutableArray()
    var networkOutData = NSMutableArray()
    var diskReadData = NSMutableArray()
    var diskWriteData = NSMutableArray()
    
    var pieChartView: PieChartView!
    var scrollView: UIScrollView!
    
    let WIDTH = UIScreen.main.bounds.width
    let HEIGHT = UIScreen.main.bounds.height
    let PIE_CHART_HEIGHT:CGFloat = 300
    
    var scrollViewHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        self.setView()
    }
    
    private func getData() {
        do{
            let cpuUtilization = try PFCloud.callFunction("ec2Watch", withParameters: getParams(metrics: "CPUUtilization", range: 20))
            let networkIn = try PFCloud.callFunction("ec2Watch", withParameters: getParams(metrics: "NetworkIn", range: 60))
            let networkOut = try PFCloud.callFunction("ec2Watch", withParameters: getParams(metrics: "NetworkOut", range: 60))
            let diskReadBytes = try PFCloud.callFunction("ec2Watch", withParameters: getParams(metrics: "DiskReadBytes", range: 60))
            let diskWriteBytes = try PFCloud.callFunction("ec2Watch", withParameters: getParams(metrics: "DiskWriteBytes", range: 60))
            
            
            let jsonParser = VMWEC2JSONParser(inputData: cpuUtilization)
            try jsonParser.printData()
            self.cpuUtilizationData = try jsonParser.getAverageData(category: EC2_AVERAGE)
            jsonParser.setData(inputData: networkIn)
            try jsonParser.printData()
            self.networkInData = try jsonParser.getDataPointsArray(category: EC2_AVERAGE)
            jsonParser.setData(inputData: networkOut)
            self.networkOutData = try jsonParser.getDataPointsArray(category: EC2_AVERAGE)
            jsonParser.setData(inputData: diskReadBytes)
            self.diskReadData = try jsonParser.getDataPointsArray(category: EC2_AVERAGE)
            jsonParser.setData(inputData: diskWriteBytes)
            self.diskWriteData = try jsonParser.getDataPointsArray(category: EC2_AVERAGE)
            
        } catch VMWEC2JSONParserError.InvalidEC2JSONDataError {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Error while parsing the JSON data",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch let error as NSError {
            NSLog("Error with request: \(error)")
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Unexpected Error",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }
    }
    
    private func setView(){
        if(cpuUtilizationData < 1){
            cpuUtilizationData = 1
        }
        print("CPUUtilization: " + String(cpuUtilizationData.roundTo(places: 1)) + " %")
        
        scrollView = UIScrollView(frame: CGRect(x:0, y:0, width: WIDTH, height: HEIGHT))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.backgroundColor = UIColor.clear.cgColor
        self.view.addSubview(scrollView)
        
        pieChartView = PieChartView(frame: CGRect(x:0, y:0, width: WIDTH, height: PIE_CHART_HEIGHT))
        pieChartView.layer.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha:1.0).cgColor
        let results = ["Used", "Not Used"]
        let percentage = [cpuUtilizationData.roundTo(places: 0), (100.0 - cpuUtilizationData).roundTo(places: 0)]
        setChart(dataPoints: results, values: percentage)
        self.scrollView.addSubview(pieChartView)
        scrollViewHeight += PIE_CHART_HEIGHT
        
        scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)
    }
    
    /*Set up pie chart*/
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "CPUUtilization Percentage")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.centerText = "CPUUtilization"
        pieChartView.holeColor = UIColor.white
        
        let colors: [UIColor] = [
            UIColor(red: 2.0/255.0, green: 119.0/255.0, blue: 189.0/255.0, alpha: 1.0),
            UIColor.white
        ]
        pieChartDataSet.colors = colors
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getParams(metrics:String, range:Int) -> [NSObject:AnyObject] {
        return [
            "accessid" as NSObject: self.accessID as AnyObject,
            "accesskey" as NSObject: self.accessKey as AnyObject,
            "instanceid" as NSObject: self.instanceID as AnyObject,
            "region" as NSObject: self.region as AnyObject,
            "metrics" as NSObject: metrics as AnyObject,
            "range" as NSObject: range as AnyObject
            ] as [NSObject:AnyObject]
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
