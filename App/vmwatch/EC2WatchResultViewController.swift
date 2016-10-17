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
    @IBOutlet weak var CPUUtilizationLabel: UILabel!
    
    let WIDTH = UIScreen.main.bounds.width
    let HEIGHT = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CPUUtilizationLabel.text = "CPUUtilization: " + String(cpuUtilizationData.roundTo(places: 1)) + " %"
        pieChartView = PieChartView(frame: CGRect(x:0, y:0, width: WIDTH, height: HEIGHT))
        let results = ["Used", "Not Used"]
        let percentage = [cpuUtilizationData.roundTo(places: 0), (100.0 - cpuUtilizationData).roundTo(places: 0)]
        setChart(dataPoints: results, values: percentage)
        self.view.addSubview(pieChartView)
        
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
