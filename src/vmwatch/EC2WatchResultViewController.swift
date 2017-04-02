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
    
    var storeInstance:Bool! = false
    
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
    let CHART_HEIGHT:CGFloat = 260
    
    var scrollViewHeight:CGFloat = 0
    
    var invalidInstanceIdOrRegion:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setView(){
        self.setScrollView()
        self.setLogoView()
        self.setInstanceIDView()
        self.drawCPUUtilizationChart()
        self.drawNetworkInChart()
        self.drawNetworkOutChart()
        self.drawDiskReadBytesChart()
        self.drawDiskWriteBytesChart()
        scrollView.contentSize = CGSize(width: WIDTH, height: scrollViewHeight)
        
        if(self.invalidInstanceIdOrRegion == true){
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Invalid Instance ID or Region, please return to the previous page",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }
        
        if(self.storeInstance == true){
            self.storeAccessCredential()
        }
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
        
        let logo = UIImage(named: "aws-logo")
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
    
    func drawCPUUtilizationChart(){
        scrollViewHeight += 5
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight + 5, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        cpuUtilizationChartView = PieChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        cpuUtilizationChartView.layer.backgroundColor = UIColor.clear.cgColor
        //cpuUtilizationChartView.lab
        
        let results = ["Used", "Not Used"]
        cpuUtilizationChartView.noDataText = "Loading Data"
        
        PFCloud.callFunction(inBackground: "ec2Watch", withParameters: getParams(metrics: "CPUUtilization", range: 10)) { (response, error) in
            if(error == nil){
                self.storeHistory()
                if(PFUser.current() != nil && self.storeInstance == true){
                    self.storeAccessCredential()
                }
                
                do {
                    let jsonParser = VMWEC2JSONParser(inputData: response)
                    self.cpuUtilizationData = try jsonParser.getAverageData(category: EC2_AVERAGE)
                    
                    if(self.cpuUtilizationData < 1){
                        self.cpuUtilizationData = 1
                    }
                    
                    let percentage = [self.cpuUtilizationData.roundTo(places: 0), (100.0 - self.cpuUtilizationData).roundTo(places: 0)]
                    
                    self.cpuUtilizationChartView.data = self.setPieChart(label: "", dataPoints: results, values: percentage)
                    self.cpuUtilizationChartView.centerText = String(self.cpuUtilizationData.roundTo(places: 0)) + " %"
                    
                }  catch VMWEC2JSONParserError.InvalidEC2JSONDataError {
                    self.networkInChartView.noDataText = "Paring issue, please retry"
                } catch VMWEC2JSONParserError.InvalidInstanceIdOrRegionError {
                    self.networkInChartView.noDataText = "Invalid Instance ID or Region"
                    self.invalidInstanceIdOrRegion = true
                } catch {
                    self.networkInChartView.noDataText = "Unexpected Error"
                }
            }else{
                self.cpuUtilizationChartView.noDataText = "Connection issue, please retry"
            }
        }
        
        cpuUtilizationChartView.noDataTextColor = UIColor.white
        cpuUtilizationChartView.holeColor = UIColor.clear
        
        cpuUtilizationChartView.chartDescription?.textColor = UIColor.white
        cpuUtilizationChartView.chartDescription?.text = "CPU Utilization (Percentage)"
        cpuUtilizationChartView.holeRadiusPercent = CGFloat(0.7)
        cpuUtilizationChartView.drawCenterTextEnabled = true
        cpuUtilizationChartView.highlightPerTapEnabled = false
        cpuUtilizationChartView.rotationEnabled = false
        
        base.addSubview(cpuUtilizationChartView)
        self.scrollView.addSubview(base)
        scrollViewHeight += CHART_HEIGHT
    }
    
    func drawNetworkInChart(){
        
        scrollViewHeight += 5
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight + 5, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        networkInChartView = LineChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        networkInChartView.layer.backgroundColor = UIColor.clear.cgColor
        self.networkInChartView.chartDescription?.text = ""
        self.networkInChartView.chartDescription?.textColor = UIColor.white
        self.networkInChartView.noDataText = "Loading data"
        
        PFCloud.callFunction(inBackground: "ec2Watch", withParameters: getParams(metrics: "NetworkIn", range: 60)) { (response, error) in
            if(error == nil){
                do {
                    let jsonParser = VMWEC2JSONParser(inputData: response)
                    self.networkInData = try jsonParser.getDataPointsArray(category: EC2_AVERAGE)
                    self.networkInChartView.data = self.setLineChart(label: "Network In(Byte)", data: self.networkInData)
                } catch VMWEC2JSONParserError.InvalidEC2JSONDataError {
                    self.networkInChartView.noDataText = "Paring issue, please retry"
                } catch VMWEC2JSONParserError.InvalidInstanceIdOrRegionError {
                        self.networkInChartView.noDataText = "Invalid Instance ID or Region"
                        self.invalidInstanceIdOrRegion = true
                } catch {
                    self.networkInChartView.noDataText = "Unexpected Error"
                }
            }else{
                self.networkInChartView.noDataText = "Connection issue, please retry"
            }
        }
        
        self.networkInChartView.gridBackgroundColor = UIColor.white
        //self.networkInChartView.drawGridBackgroundEnabled = false
        //self.networkInChartView.dr
        
        base.addSubview(networkInChartView)
        self.scrollView.addSubview(base)
        scrollViewHeight += CHART_HEIGHT
    }
    
    func drawNetworkOutChart(){
        
        scrollViewHeight += 5
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight + 5, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        networkOutChartView = LineChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        networkOutChartView.layer.backgroundColor = UIColor.clear.cgColor
        self.networkOutChartView.chartDescription?.text = "Tap node for details"
        self.networkOutChartView.chartDescription?.textColor = UIColor.black
        self.networkOutChartView.gridBackgroundColor = UIColor.darkGray
        self.networkOutChartView.noDataText = "Loading data"
        
        PFCloud.callFunction(inBackground: "ec2Watch", withParameters: getParams(metrics: "NetworkOut", range: 60)) { (response, error) in
            if(error == nil){
                do {
                    let jsonParser = VMWEC2JSONParser(inputData: response)
                    self.networkOutData = try jsonParser.getDataPointsArray(category: EC2_AVERAGE)
                    self.networkOutChartView.data = self.setLineChart(label: "Network Out(Byte)", data: self.networkOutData)
                }  catch VMWEC2JSONParserError.InvalidEC2JSONDataError {
                    self.networkInChartView.noDataText = "Paring issue, please retry"
                } catch VMWEC2JSONParserError.InvalidInstanceIdOrRegionError {
                    self.networkInChartView.noDataText = "Invalid Instance ID or Region"
                    self.invalidInstanceIdOrRegion = true
                } catch {
                    self.networkInChartView.noDataText = "Unexpected Error"
                }
            }else{
                self.networkOutChartView.noDataText = "Connection issue, please retry"
            }
        }
        
        base.addSubview(networkOutChartView)
        self.scrollView.addSubview(base)
        scrollViewHeight += CHART_HEIGHT
        
    }
    
    func drawDiskReadBytesChart(){
        
        scrollViewHeight += 5
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight + 5, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        diskReadChartView = LineChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        diskReadChartView.layer.backgroundColor = UIColor.clear.cgColor
        self.diskReadChartView.chartDescription?.text = "Tap node for details"
        self.diskReadChartView.chartDescription?.textColor = UIColor.black
        self.diskReadChartView.gridBackgroundColor = UIColor.darkGray
        self.diskReadChartView.noDataText = "Loading data"
        
        PFCloud.callFunction(inBackground: "ec2Watch", withParameters: getParams(metrics: "DiskReadBytes", range: 60)) { (response, error) in
            if(error == nil){
                do {
                    let jsonParser = VMWEC2JSONParser(inputData: response)
                    self.diskReadData = try jsonParser.getDataPointsArray(category: EC2_AVERAGE)
                    self.diskReadChartView.data = self.setLineChart(label: "Disk Read(Byte)", data: self.diskReadData)
                }  catch VMWEC2JSONParserError.InvalidEC2JSONDataError {
                    self.networkInChartView.noDataText = "Paring issue, please retry"
                } catch VMWEC2JSONParserError.InvalidInstanceIdOrRegionError {
                    self.networkInChartView.noDataText = "Invalid Instance ID or Region"
                    self.invalidInstanceIdOrRegion = true
                } catch {
                    self.networkInChartView.noDataText = "Unexpected Error"
                }
            }else{
                self.diskReadChartView.noDataText = "Connection issue, please retry"
            }
        }
        
        base.addSubview(diskReadChartView)
        self.scrollView.addSubview(base)
        scrollViewHeight += CHART_HEIGHT
    }
    
    func drawDiskWriteBytesChart(){
        
        scrollViewHeight += 5
        let base = UIView(frame: CGRect(x:25, y:scrollViewHeight + 5, width: WIDTH - 50, height: CHART_HEIGHT))
        base.backgroundColor = UIColor(red: 39 / 255, green: 57 / 255, blue: 74 / 255, alpha: 1)
        
        diskWriteChartView = LineChartView(frame: CGRect(x:0, y:0, width: base.frame.width, height: base.frame.height))
        diskWriteChartView.layer.backgroundColor = UIColor.clear.cgColor
        self.diskWriteChartView.chartDescription?.text = "Tap node for details"
        self.diskWriteChartView.chartDescription?.textColor = UIColor.black
        self.diskWriteChartView.gridBackgroundColor = UIColor.darkGray
        self.diskWriteChartView.noDataText = "Loading Data"
        
        PFCloud.callFunction(inBackground: "ec2Watch", withParameters: getParams(metrics: "DiskWriteBytes", range: 60)) { (response, error) in
            if(error == nil){
                do {
                    let jsonParser = VMWEC2JSONParser(inputData: response)
                    self.diskWriteData = try jsonParser.getDataPointsArray(category: EC2_AVERAGE)
                    self.diskWriteChartView.data = self.setLineChart(label: "Disk Write(Byte)", data: self.diskWriteData)
                }  catch VMWEC2JSONParserError.InvalidEC2JSONDataError {
                    self.networkInChartView.noDataText = "Paring issue, please retry"
                } catch VMWEC2JSONParserError.InvalidInstanceIdOrRegionError {
                    self.networkInChartView.noDataText = "Invalid Instance ID or Region"
                    self.invalidInstanceIdOrRegion = true
                } catch {
                    self.networkInChartView.noDataText = "Unexpected Error"
                }
            }else{
                self.diskWriteChartView.noDataText = "Connection issue, please retry"
            }
        }
        
        base.addSubview(diskWriteChartView)
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
            yVals1.append(ChartDataEntry(x: Double(i),y: dict["data"] as! Double))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: label)
        set1.axisDependency = .left
        set1.setColor(UIColor.blue.withAlphaComponent(0.5))
        set1.setCircleColor(UIColor.blue)
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
    
    func storeHistory(){
        
        let history = VMWEC2HistoryStorage()
        do{
            try history.deleteHistoryRecord(accessID: self.accessID!, accessKey: self.accessKey!, instanceID: self.instanceID!, region: self.region!)
            try history.storeEC2History(accessID: self.accessID!, accessKey: self.accessKey!, instanceID: self.instanceID!, region: self.region!)
        } catch VMWEC2CoreDataStorageError.DatabaseStoreError {
            NSLog("Could not save the history data due to database issue")
        } catch VMWEC2CoreDataStorageError.DatabaseDeleteError {
            NSLog("Fail to remove previous history data due to database issue")
        } catch {
            NSLog("Unexpected database issue")
        }
    }
    
    func storeAccessCredential(){
        let storeParams = [
            "accessid" as NSObject: self.accessID! as AnyObject,
            "accesskey" as NSObject: self.accessKey! as AnyObject,
            "instanceid" as NSObject: self.instanceID! as AnyObject,
            "region" as NSObject: self.region as AnyObject,
            "userid" as NSObject: PFUser.current()?.objectId! as AnyObject
            ] as [NSObject:AnyObject]
        
        PFCloud.callFunction(inBackground: "ec2UserDataStore", withParameters: storeParams) { (response, ec2StoreError) in
            if(ec2StoreError == nil){
                NSLog("Instance Stored")
            }else{
                NSLog("Store Failed: " + ec2StoreError.debugDescription)
            }
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
