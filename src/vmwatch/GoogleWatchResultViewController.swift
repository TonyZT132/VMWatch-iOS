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
        let title = UILabel(frame: CGRect(x: 25, y: scrollViewHeight, width: WIDTH - 50, height: 20))
        title.text = self.instanceID
        title.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        title.font = title.font.withSize(12)
        title.textColor = .white
        title.textAlignment = .center
        scrollView.addSubview(title)
        scrollViewHeight += title.frame.height
    }
    
    func setTitleView(titleName:String){
        //scrollViewHeight += 5
        let title = UILabel(frame: CGRect(x: 25, y: scrollViewHeight, width: WIDTH - 50, height: 25) )
        title.text = titleName
        title.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        title.font = title.font.withSize(14)
        title.textColor = .white
        title.textAlignment = .center
        scrollView.addSubview(title)
        scrollViewHeight += title.frame.height
    }
    
    
    func drawCpuInChart(){
        scrollViewHeight += 5
        setTitleView(titleName: "CPU Utilization")
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight, width: WIDTH - 50, height: CHART_HEIGHT))
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
                
                self.cpuInChartView.data = self.setPieChart(label: "", dataPoints: results, values: percentage)
                self.cpuInChartView.centerText = "Used: " + String(self.cpuInData.roundTo(places: 0)) + " %"

            } catch GoogleJSONParserError.InvalidGoogleJSONDataError {
                self.cpuInChartView.noDataText = "Paring issue, please retry"
            } catch {
                self.cpuInChartView.noDataText = "Unexpected Error"
            }
        }else{
            self.cpuInChartView.noDataText = "Connection issue, please retry"
        }
        
        
        //cpuInChartView.centerText = "CPUUtilization"
        //cpuInChartView.holeColor = UIColor.white
        
        cpuInChartView.noDataTextColor = UIColor.white
        cpuInChartView.holeColor = UIColor.clear
        
        cpuInChartView.holeRadiusPercent = CGFloat(0.7)
        cpuInChartView.drawCenterTextEnabled = true
        cpuInChartView.highlightPerTapEnabled = false
        cpuInChartView.rotationEnabled = false
        
        base.addSubview(cpuInChartView)
        self.scrollView.addSubview(base)
        scrollViewHeight += CHART_HEIGHT
    }
    
    
    func drawNetworkSentInChart(){
        
        scrollViewHeight += 5
        setTitleView(titleName: "Network Sent(Byte)")
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        networksentInChartView = LineChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        networksentInChartView.layer.backgroundColor = UIColor.clear.cgColor
        networksentInChartView.xAxis.labelTextColor = UIColor.white
        networksentInChartView.leftAxis.labelTextColor = UIColor.white
        networksentInChartView.rightAxis.labelTextColor = UIColor.white

        self.networksentInChartView.chartDescription?.text = ""
        self.networksentInChartView.chartDescription?.textColor = UIColor.white
        self.networksentInChartView.gridBackgroundColor = UIColor.white
        self.networksentInChartView.noDataText = "Loading data"
        
        
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.networksentInData = try jsonParser.getOtherArray(type: "network_sent")
                //print(self.networksentInData)
                self.networksentInChartView.data = self.setLineChart(label: "", data: self.networksentInData)
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
        setTitleView(titleName: "Network Received(Byte)")
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        networkreceivedInChartView = LineChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        networkreceivedInChartView.layer.backgroundColor = UIColor.clear.cgColor
        networkreceivedInChartView.xAxis.labelTextColor = UIColor.white
        networkreceivedInChartView.leftAxis.labelTextColor = UIColor.white
        networkreceivedInChartView.rightAxis.labelTextColor = UIColor.white
        
        self.networkreceivedInChartView.chartDescription?.text = ""
        self.networkreceivedInChartView.chartDescription?.textColor = UIColor.white
        self.networkreceivedInChartView.gridBackgroundColor = UIColor.white
        self.networkreceivedInChartView.noDataText = "Loading data"
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.networkreceivedInData = try jsonParser.getOtherArray(type: "network_received")
                self.networkreceivedInChartView.data = self.setLineChart(label: "", data: self.networkreceivedInData)
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
        setTitleView(titleName: "Disk Read(Byte)")
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        diskreadInChartView = LineChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        diskreadInChartView.layer.backgroundColor = UIColor.clear.cgColor
        diskreadInChartView.xAxis.labelTextColor = UIColor.white
        diskreadInChartView.leftAxis.labelTextColor = UIColor.white
        diskreadInChartView.rightAxis.labelTextColor = UIColor.white
        
        self.diskreadInChartView.chartDescription?.text = ""
        self.diskreadInChartView.chartDescription?.textColor = UIColor.white
        self.diskreadInChartView.gridBackgroundColor = UIColor.white
        self.diskreadInChartView.noDataText = "Loading data"
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.diskreadInData = try jsonParser.getOtherArray(type: "disk_read")
                self.diskreadInChartView.data = self.setLineChart(label: "", data: self.diskreadInData)
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
        setTitleView(titleName: "Disk Write(Byte)")
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        diskwriteInChartView = LineChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        diskwriteInChartView.layer.backgroundColor = UIColor.clear.cgColor
        diskwriteInChartView.xAxis.labelTextColor = UIColor.white
        diskwriteInChartView.leftAxis.labelTextColor = UIColor.white
        diskwriteInChartView.rightAxis.labelTextColor = UIColor.white
        
        
        self.diskwriteInChartView.chartDescription?.text = ""
        self.diskwriteInChartView.chartDescription?.textColor = UIColor.white
        self.diskwriteInChartView.gridBackgroundColor = UIColor.white
        self.diskwriteInChartView.noDataText = "Loading Data"
        
        if(response != nil){
            do {
                let jsonParser = GoogleJSONParser(inputData: response)
                self.diskwriteInData = try jsonParser.getOtherArray(type: "disk_write")
                self.diskwriteInChartView.data = self.setLineChart(label: "", data: self.diskwriteInData)
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
        //let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)

        

        let colors: [UIColor] = [
            UIColor(red: 98 / 255, green: 187 / 255, blue: 255 / 255, alpha: 1),
            UIColor(red: 121 / 255, green: 101 / 255, blue: 241 / 255, alpha: 1),

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
        set1.setColor(UIColor(red: 98 / 255, green: 187 / 255, blue: 255 / 255, alpha: 1))
        set1.setCircleColor(UIColor(red: 98 / 255, green: 187 / 255, blue: 255 / 255, alpha: 1))
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.blue
        set1.highlightColor = UIColor.blue
        set1.drawCircleHoleEnabled = false
        set1.drawCirclesEnabled = false
        set1.drawVerticalHighlightIndicatorEnabled = false
        set1.drawHorizontalHighlightIndicatorEnabled = false
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.white)
        return data
    }


}
