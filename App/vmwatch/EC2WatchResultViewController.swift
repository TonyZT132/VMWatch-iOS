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
    
    var cpuUtilizationChartView: PieChartView!
    var networkInChartView: LineChartView!
    var networkOutChartView: LineChartView!
    var diskReadChartView: LineChartView!
    var diskWriteChartView: LineChartView!
    var scrollView: UIScrollView!
    
    let WIDTH = UIScreen.main.bounds.width
    let HEIGHT = UIScreen.main.bounds.height
    let CHART_HEIGHT:CGFloat = 300
    
    var scrollViewHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
    }
    
    private func getData() {
        do{
            let cpuUtilization = try PFCloud.callFunction("ec2Watch", withParameters: getParams(metrics: "CPUUtilization", range: 10))
            let networkIn = try PFCloud.callFunction("ec2Watch", withParameters: getParams(metrics: "NetworkIn", range: 60))
            let networkOut = try PFCloud.callFunction("ec2Watch", withParameters: getParams(metrics: "NetworkOut", range: 60))
            let diskReadBytes = try PFCloud.callFunction("ec2Watch", withParameters: getParams(metrics: "DiskReadBytes", range: 60))
            let diskWriteBytes = try PFCloud.callFunction("ec2Watch", withParameters: getParams(metrics: "DiskWriteBytes", range: 60))
            
            let jsonParser = VMWEC2JSONParser(inputData: cpuUtilization)
            self.cpuUtilizationData = try jsonParser.getAverageData(category: EC2_AVERAGE)
            
            jsonParser.setData(inputData: networkIn)
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
                    message: "Error while parsing the data",
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
        self.getData()
        if(cpuUtilizationData < 1){
            cpuUtilizationData = 1
        }
        print("CPUUtilization: " + String(cpuUtilizationData.roundTo(places: 1)) + " %")
        
        scrollView = UIScrollView(frame: CGRect(x:0, y:0, width: WIDTH, height: HEIGHT))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.backgroundColor = UIColor.clear.cgColor
        self.view.addSubview(scrollView)
        
        
        cpuUtilizationChartView = PieChartView(frame: CGRect(x:0, y:0, width: WIDTH, height: CHART_HEIGHT))
        cpuUtilizationChartView.layer.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha:1.0).cgColor
        let results = ["Used", "Not Used"]
        let percentage = [cpuUtilizationData.roundTo(places: 0), (100.0 - cpuUtilizationData).roundTo(places: 0)]
        
        cpuUtilizationChartView.data = setPieChart(dataPoints: results, values: percentage)
        cpuUtilizationChartView.centerText = "CPUUtilization"
        cpuUtilizationChartView.holeColor = UIColor.white
        
        self.scrollView.addSubview(cpuUtilizationChartView)
        scrollViewHeight += CHART_HEIGHT
        
        
        networkInChartView = LineChartView(frame: CGRect(x:0, y:scrollViewHeight, width: WIDTH, height: CHART_HEIGHT))
        networkInChartView.layer.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha:1.0).cgColor
        self.networkInChartView.chartDescription?.text = "Tap node for details"
        self.networkInChartView.chartDescription?.textColor = UIColor.black
        self.networkInChartView.gridBackgroundColor = UIColor.darkGray
        self.networkInChartView.noDataText = "No data provided"
        self.networkInChartView.data = setLineChart(label: "NetworkIn", data: self.networkInData)
        
        self.scrollView.addSubview(networkInChartView)
        scrollViewHeight += CHART_HEIGHT
        
        
        networkOutChartView = LineChartView(frame: CGRect(x:0, y:scrollViewHeight, width: WIDTH, height: CHART_HEIGHT))
        networkOutChartView.layer.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha:1.0).cgColor
        self.networkOutChartView.chartDescription?.text = "Tap node for details"
        self.networkOutChartView.chartDescription?.textColor = UIColor.black
        self.networkOutChartView.gridBackgroundColor = UIColor.darkGray
        self.networkOutChartView.noDataText = "No data provided"
        self.networkOutChartView.data = setLineChart(label: "NetworkOut", data: self.networkOutData)
        
        self.scrollView.addSubview(networkOutChartView)
        scrollViewHeight += CHART_HEIGHT
        
        
        diskReadChartView = LineChartView(frame: CGRect(x:0, y:scrollViewHeight, width: WIDTH, height: CHART_HEIGHT))
        diskReadChartView.layer.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha:1.0).cgColor
        self.diskReadChartView.chartDescription?.text = "Tap node for details"
        self.diskReadChartView.chartDescription?.textColor = UIColor.black
        self.diskReadChartView.gridBackgroundColor = UIColor.darkGray
        self.diskReadChartView.noDataText = "No data provided"
        self.diskReadChartView.data = setLineChart(label: "DiskRead", data: self.diskReadData)
        
        self.scrollView.addSubview(diskReadChartView)
        scrollViewHeight += CHART_HEIGHT
        
        
        diskWriteChartView = LineChartView(frame: CGRect(x:0, y:scrollViewHeight, width: WIDTH, height: CHART_HEIGHT))
        diskWriteChartView.layer.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha:1.0).cgColor
        self.diskWriteChartView.chartDescription?.text = "Tap node for details"
        self.diskWriteChartView.chartDescription?.textColor = UIColor.black
        self.diskWriteChartView.gridBackgroundColor = UIColor.darkGray
        self.diskWriteChartView.noDataText = "No data provided"
        self.diskWriteChartView.data = setLineChart(label: "DiskWrite", data: self.diskWriteData)
        
        self.scrollView.addSubview(diskWriteChartView)
        scrollViewHeight += CHART_HEIGHT
        
        scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)
    }
    
    /*Set up pie chart*/
    func setPieChart(dataPoints: [String], values: [Double]) -> PieChartData {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "CPUUtilization Percentage")
        let colors: [UIColor] = [
            UIColor(red: 2.0/255.0, green: 119.0/255.0, blue: 189.0/255.0, alpha: 1.0),
            UIColor.white
        ]
        pieChartDataSet.colors = colors
        return PieChartData(dataSet: pieChartDataSet)
    }
    
    func setLineChart(label:String, data:NSMutableArray) -> LineChartData {
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< data.count {
            let dict = data[i] as! NSDictionary
            yVals1.append(ChartDataEntry(x: Double(i),y: dict["data"] as! Double))
        }

        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: label)
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.red.withAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(UIColor.red) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.yellow
        set1.highlightColor = UIColor.green
        set1.drawCircleHoleEnabled = true
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)

        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.red)
        return data
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
