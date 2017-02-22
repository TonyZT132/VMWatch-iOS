//
//  GoogleResultViewController.swift
//  vmwatch
//
//  Created by Yanrong Wang on 2017-02-21.
//  Copyright © 2017 ECE496. All rights reserved.
//

import UIKit

class GoogleResultViewController: UIViewController {
    
    var response: Any?
    
    var cpuInChartView: LineChartView!
    var cpuInData = NSMutableArray()
    
    var diskreadInChartView: LineChartView!
    var diskreadInData = NSMutableArray()
    
    var diskwriteInChartView: LineChartView!
    var diskwriteInData = NSMutableArray()
    
    var networksentInChartView: LineChartView!
    var networksentInData = NSMutableArray()
    
    var networkreceivedInChartView: LineChartView!
    var networkreceivedInData = NSMutableArray()
    
    

    var scrollView: UIScrollView!
    let WIDTH = UIScreen.main.bounds.width
    let HEIGHT = UIScreen.main.bounds.height
    let CHART_HEIGHT:CGFloat = 300
    var scrollViewHeight:CGFloat = 0

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setView(){
        scrollView = UIScrollView(frame: CGRect(x:0, y:0, width: WIDTH, height: HEIGHT))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.backgroundColor = UIColor.clear.cgColor
        self.view.addSubview(scrollView)
        self.drawCpuInChart()
        self.drawDiskReadInChart()
        self.drawDiskWriteInChart()
        self.drawNetworkReceivedInChart()
        self.drawNetworkSentInChart()
        scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)
        
    }
    
    
    func drawCpuInChart(){
        cpuInChartView = LineChartView(frame: CGRect(x:0, y:scrollViewHeight, width: WIDTH, height: CHART_HEIGHT))
        cpuInChartView.layer.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha:1.0).cgColor
        self.cpuInChartView.chartDescription?.text = "Tap node for details"
        self.cpuInChartView.chartDescription?.textColor = UIColor.black
        self.cpuInChartView.gridBackgroundColor = UIColor.darkGray
        self.cpuInChartView.noDataText = "Loading data"
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.cpuInData = try jsonParser.getCpuArray(type: "cpu")
                self.cpuInChartView.data = self.setLineChart(label: "CPU In(Percentage)", data: self.cpuInData)
                } catch GoogleJSONParserError.InvalidGoogleJSONDataError {
                    self.cpuInChartView.noDataText = "Paring issue, please retry"
                } catch {
                    self.cpuInChartView.noDataText = "Unexpected Error"
                }
            }else{
                self.cpuInChartView.noDataText = "Connection issue, please retry"
            }
        self.scrollView.addSubview(cpuInChartView)
        scrollViewHeight += CHART_HEIGHT
    }
    
    
    func drawDiskReadInChart(){
        diskreadInChartView = LineChartView(frame: CGRect(x:0, y:scrollViewHeight, width: WIDTH, height: CHART_HEIGHT))
        diskreadInChartView.layer.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha:1.0).cgColor
        self.diskreadInChartView.chartDescription?.text = "Tap node for details"
        self.diskreadInChartView.chartDescription?.textColor = UIColor.black
        self.diskreadInChartView.gridBackgroundColor = UIColor.darkGray
        self.diskreadInChartView.noDataText = "Loading data"
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.diskreadInData = try jsonParser.getOtherArray(type: "disk_read")
                self.diskreadInChartView.data = self.setLineChart(label: "Disk Read In(Bytes)", data: self.cpuInData)
            } catch GoogleJSONParserError.InvalidGoogleJSONDataError {
                self.diskreadInChartView.noDataText = "Paring issue, please retry"
            } catch {
                self.diskreadInChartView.noDataText = "Unexpected Error"
            }
        }else{
            self.diskreadInChartView.noDataText = "Connection issue, please retry"
        }
        self.scrollView.addSubview(diskreadInChartView)
        scrollViewHeight += CHART_HEIGHT
    }
    
    
    func drawDiskWriteInChart(){
        diskwriteInChartView = LineChartView(frame: CGRect(x:0, y:scrollViewHeight, width: WIDTH, height: CHART_HEIGHT))
        diskwriteInChartView.layer.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha:1.0).cgColor
        self.diskwriteInChartView.chartDescription?.text = "Tap node for details"
        self.diskwriteInChartView.chartDescription?.textColor = UIColor.black
        self.diskwriteInChartView.gridBackgroundColor = UIColor.darkGray
        self.diskwriteInChartView.noDataText = "Loading data"
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.diskwriteInData = try jsonParser.getOtherArray(type: "disk_write")
                self.diskwriteInChartView.data = self.setLineChart(label: "Disk Write In(Bytes)", data: self.cpuInData)
            } catch GoogleJSONParserError.InvalidGoogleJSONDataError {
                self.diskwriteInChartView.noDataText = "Paring issue, please retry"
            } catch {
                self.diskwriteInChartView.noDataText = "Unexpected Error"
            }
        }else{
            self.diskwriteInChartView.noDataText = "Connection issue, please retry"
        }
        self.scrollView.addSubview(diskwriteInChartView)
        scrollViewHeight += CHART_HEIGHT
    }
    
    
    func drawNetworkSentInChart(){
        networksentInChartView = LineChartView(frame: CGRect(x:0, y:scrollViewHeight, width: WIDTH, height: CHART_HEIGHT))
        networksentInChartView.layer.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha:1.0).cgColor
        self.networksentInChartView.chartDescription?.text = "Tap node for details"
        self.networksentInChartView.chartDescription?.textColor = UIColor.black
        self.networksentInChartView.gridBackgroundColor = UIColor.darkGray
        self.networksentInChartView.noDataText = "Loading data"
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.networksentInData = try jsonParser.getOtherArray(type: "network_sent")
                self.networksentInChartView.data = self.setLineChart(label: "Network Sent In(Bytes)", data: self.cpuInData)
            } catch GoogleJSONParserError.InvalidGoogleJSONDataError {
                self.networksentInChartView.noDataText = "Paring issue, please retry"
            } catch {
                self.networksentInChartView.noDataText = "Unexpected Error"
            }
        }else{
            self.networksentInChartView.noDataText = "Connection issue, please retry"
        }
        self.scrollView.addSubview(networksentInChartView)
        scrollViewHeight += CHART_HEIGHT
    }
    
    
    func drawNetworkReceivedInChart(){
        networkreceivedInChartView = LineChartView(frame: CGRect(x:0, y:scrollViewHeight, width: WIDTH, height: CHART_HEIGHT))
        networkreceivedInChartView.layer.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha:1.0).cgColor
        self.networkreceivedInChartView.chartDescription?.text = "Tap node for details"
        self.networkreceivedInChartView.chartDescription?.textColor = UIColor.black
        self.networkreceivedInChartView.gridBackgroundColor = UIColor.darkGray
        self.networkreceivedInChartView.noDataText = "Loading data"
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.networkreceivedInData = try jsonParser.getOtherArray(type: "network_received")
                self.networkreceivedInChartView.data = self.setLineChart(label: "Network Received In(Bytes)", data: self.cpuInData)
            } catch GoogleJSONParserError.InvalidGoogleJSONDataError {
                self.networkreceivedInChartView.noDataText = "Paring issue, please retry"
            } catch {
                self.networkreceivedInChartView.noDataText = "Unexpected Error"
            }
        }else{
            self.networkreceivedInChartView.noDataText = "Connection issue, please retry"
        }
        self.scrollView.addSubview(networkreceivedInChartView)
        scrollViewHeight += CHART_HEIGHT
    }
    
    
    /*Set up line chart*/
    func setLineChart(label:String, data:NSMutableArray) -> LineChartData {
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< data.count {
            let dict = data[i] as! NSDictionary
            yVals1.append(ChartDataEntry(x: Double(i),y: dict["data"] as! Double))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: label)
        set1.axisDependency = .left
        set1.setColor(UIColor.red.withAlphaComponent(0.5))
        set1.setCircleColor(UIColor.red)
        set1.lineWidth = 3.0
        set1.circleRadius = 6.0
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


}
