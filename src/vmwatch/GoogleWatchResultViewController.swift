//
//  GoogleWatchResultViewController.swift
//  vmwatch
//
//  Created by Yuxuan Zhang on 2017-03-28.
//  Copyright © 2017 ECE496. All rights reserved.
//

import UIKit

class GoogleWatchResultViewController: UIViewController {

    var response: Any?
    var instanceID:String?
    
    var cpuInChartView: PieChartView!
    var cpuInDataArray = NSMutableArray()
    var cpuInData: Double!
    
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
    let CHART_HEIGHT:CGFloat = 260
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
        let imageView   = UIImageView(frame: self.view.bounds);
        imageView.image = UIImage(named: "background")!
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        self.setScrollView()
        self.setLogoView()
        self.setInstanceIDView()
        self.drawCpuInChart()
        self.drawNetworkSentInChart()
        self.drawNetworkReceivedInChart()
        self.drawDiskReadInChart()
        self.drawDiskWriteInChart()
        scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)

        
    }
    
    func setScrollView(){
        let NavBarYPosition:CGFloat = self.navigationController!.navigationBar.frame.maxY;
        
        scrollView = UIScrollView(frame: CGRect(x:0, y: NavBarYPosition, width: WIDTH, height: HEIGHT - NavBarYPosition))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.backgroundColor = UIColor.clear.cgColor
        self.view.addSubview(scrollView)
    }
    
    func setLogoView(){
        scrollViewHeight += 25
        let logoView = UIView(frame: CGRect(x: 25, y: scrollViewHeight, width: WIDTH - 50, height: 100) )
        logoView.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        let logo = UIImage(named: "google-logo")
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: logoView.bounds.width, height: logoView.bounds.height))
        logoImageView.image = logo
        logoImageView.contentMode = UIViewContentMode.scaleAspectFit
        logoView.addSubview(logoImageView)
        
        scrollView.addSubview(logoView)
        scrollViewHeight += logoView.frame.height
    }
    
    func setInstanceIDView(){
        scrollViewHeight += 10
        let title = UILabel(frame: CGRect(x: 25, y: scrollViewHeight, width: WIDTH - 50, height: 20) )
        title.text = self.instanceID
        title.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        title.font = title.font.withSize(12)
        title.textColor = .white
        title.textAlignment = .center
        scrollView.addSubview(title)
        scrollViewHeight += title.frame.height
    }
    
    
    func drawCpuInChart(){
        scrollViewHeight += 5
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight + 5, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        cpuInChartView = PieChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        cpuInChartView.layer.backgroundColor = UIColor.clear.cgColor
        let results = ["Used", "Not Used"]
        cpuInChartView.noDataText = "Loading Data"
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.cpuInDataArray = try jsonParser.getCpuArray(type: "cpu")
                let dict = self.cpuInDataArray[2] as! NSDictionary
                //print(self.cpuInDataArray)
                self.cpuInData = dict["data"] as! Double
                
                if(self.cpuInData < 1){
                    self.cpuInData = 1
                }
                
                let percentage = [self.cpuInData.roundTo(places: 0), (100.0 - self.cpuInData).roundTo(places: 0)]
                
                self.cpuInChartView.data = self.setPieChart(label: "CPU Utilization(Percentage)", dataPoints: results, values: percentage)
            } catch GoogleJSONParserError.InvalidGoogleJSONDataError {
                self.cpuInChartView.noDataText = "Paring issue, please retry"
            } catch {
                self.cpuInChartView.noDataText = "Unexpected Error"
            }
        }else{
            self.cpuInChartView.noDataText = "Connection issue, please retry"
        }
        
        
        cpuInChartView.centerText = "CPUUtilization"
        cpuInChartView.holeColor = UIColor.white
        
        base.addSubview(cpuInChartView)
        self.scrollView.addSubview(base)
        scrollViewHeight += CHART_HEIGHT
    }
    
    
    func drawNetworkSentInChart(){
        
        scrollViewHeight += 5
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight + 5, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        networksentInChartView = LineChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        networksentInChartView.layer.backgroundColor = UIColor.clear.cgColor
        self.networksentInChartView.chartDescription?.text = "Tap node for details"
        self.networksentInChartView.chartDescription?.textColor = UIColor.black
        self.networksentInChartView.gridBackgroundColor = UIColor.darkGray
        self.networksentInChartView.noDataText = "Loading data"
        
        
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.networksentInData = try jsonParser.getOtherArray(type: "network_sent")
                print(self.networksentInData)
                self.networksentInChartView.data = self.setLineChart(label: "Network Sent In(Bytes)", data: self.networksentInData)
            } catch GoogleJSONParserError.InvalidGoogleJSONDataError {
                self.networksentInChartView.noDataText = "Paring issue, please retry"
            } catch {
                self.networksentInChartView.noDataText = "Unexpected Error"
            }
        }else{
            self.networksentInChartView.noDataText = "Connection issue, please retry"
        }
        
        base.addSubview(networksentInChartView)
        self.scrollView.addSubview(base)
        scrollViewHeight += CHART_HEIGHT
    }
    
    
    func drawNetworkReceivedInChart(){
        scrollViewHeight += 5
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight + 5, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        networkreceivedInChartView = LineChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        networkreceivedInChartView.layer.backgroundColor = UIColor.clear.cgColor
        self.networkreceivedInChartView.chartDescription?.text = "Tap node for details"
        self.networkreceivedInChartView.chartDescription?.textColor = UIColor.black
        self.networkreceivedInChartView.gridBackgroundColor = UIColor.darkGray
        self.networkreceivedInChartView.noDataText = "Loading data"
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.networkreceivedInData = try jsonParser.getOtherArray(type: "network_received")
                self.networkreceivedInChartView.data = self.setLineChart(label: "Network Received In(Bytes)", data: self.networkreceivedInData)
            } catch GoogleJSONParserError.InvalidGoogleJSONDataError {
                self.networkreceivedInChartView.noDataText = "Paring issue, please retry"
            } catch {
                self.networkreceivedInChartView.noDataText = "Unexpected Error"
            }
        }else{
            self.networkreceivedInChartView.noDataText = "Connection issue, please retry"
        }
        
        base.addSubview(networkreceivedInChartView)
        self.scrollView.addSubview(base)
        scrollViewHeight += CHART_HEIGHT
    }
 
    
    func drawDiskReadInChart(){
        scrollViewHeight += 5
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight + 5, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        diskreadInChartView = LineChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        diskreadInChartView.layer.backgroundColor = UIColor.clear.cgColor
        self.diskreadInChartView.chartDescription?.text = "Tap node for details"
        self.diskreadInChartView.chartDescription?.textColor = UIColor.black
        self.diskreadInChartView.gridBackgroundColor = UIColor.darkGray
        self.diskreadInChartView.noDataText = "Loading data"
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.diskreadInData = try jsonParser.getOtherArray(type: "disk_read")
                self.diskreadInChartView.data = self.setLineChart(label: "Disk Read In(Bytes)", data: self.diskreadInData)
            } catch GoogleJSONParserError.InvalidGoogleJSONDataError {
                self.diskreadInChartView.noDataText = "Paring issue, please retry"
            } catch {
                self.diskreadInChartView.noDataText = "Unexpected Error"
            }
        }else{
            self.diskreadInChartView.noDataText = "Connection issue, please retry"
        }
        base.addSubview(diskreadInChartView)
        self.scrollView.addSubview(base)
        scrollViewHeight += CHART_HEIGHT
    }
    
    
    func drawDiskWriteInChart(){
        scrollViewHeight += 5
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight + 5, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        diskwriteInChartView = LineChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        diskwriteInChartView.layer.backgroundColor = UIColor.clear.cgColor
        self.diskwriteInChartView.chartDescription?.text = "Tap node for details"
        self.diskwriteInChartView.chartDescription?.textColor = UIColor.black
        self.diskwriteInChartView.gridBackgroundColor = UIColor.darkGray
        self.diskwriteInChartView.noDataText = "Loading Data"
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.diskwriteInData = try jsonParser.getOtherArray(type: "disk_write")
                self.diskwriteInChartView.data = self.setLineChart(label: "Disk Write In(Bytes)", data: self.diskwriteInData)
            } catch GoogleJSONParserError.InvalidGoogleJSONDataError {
                self.diskwriteInChartView.noDataText = "Paring issue, please retry"
            } catch {
                self.diskwriteInChartView.noDataText = "Unexpected Error"
            }
        }else{
            self.diskwriteInChartView.noDataText = "Connection issue, please retry"
        }
        base.addSubview(diskwriteInChartView)
        self.scrollView.addSubview(base)
        scrollViewHeight += CHART_HEIGHT
    }



    
    
    
    
    
    
    
    
    
    
    
    
    /*Set up pie chart*/
    func setPieChart(label:String, dataPoints: [String], values: [Double]) -> PieChartData {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: label)
        let colors: [UIColor] = [
            UIColor(red: 2.0/255.0, green: 119.0/255.0, blue: 189.0/255.0, alpha: 1.0),
            UIColor.red
        ]
        pieChartDataSet.colors = colors
        return PieChartData(dataSet: pieChartDataSet)
    }
    
    /*Set up line chart*/
    func setLineChart(label:String, data:NSMutableArray) -> LineChartData {
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< data.count {
            let dict = data[i] as! NSDictionary
            let data = (dict["data"] as! NSString).doubleValue
            yVals1.append(ChartDataEntry(x: Double(i),y: data as! Double))
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
