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
    @IBOutlet weak var CPUUtilizationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CPUUtilizationLabel.text = "CPUUtilization: " + String(cpuUtilizationData.roundTo(places: 2)) + " %"
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
