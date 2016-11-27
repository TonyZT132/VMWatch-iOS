//
//  EC2WatchResultViewController.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2016-10-16.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class EC2WatchResultViewController: UIViewController {

    var cpuUtilizationData:Double!
    var pieChartView: PieChartView!
    var scrollView: UIScrollView!
    
    let WIDTH = UIScreen.main.bounds.width
    let HEIGHT = UIScreen.main.bounds.height
    let PIE_CHART_HEIGHT:CGFloat = 300
    
    var scrollViewHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            UIColor(red: 255.0/255.0, green: 69.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        ]
        pieChartDataSet.colors = colors
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
