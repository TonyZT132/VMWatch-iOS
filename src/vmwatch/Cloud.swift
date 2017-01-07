//
//  cloud.swift
//  VMWatcher
//
//  Created by Tuo Zhang on 2016-06-25.
//  Copyright © 2016 ECE496. All rights reserved.
//

import Foundation


let SERVICE = [
    [
        "id":0,
        "name":"aws",
        "icon":"aws-logo",
        "avaliable":true
    ],
    [
        "id":1,
        "name":"azure",
        "icon":"azure-logo",
        "avaliable":false
    ],
    [
        "id":2,
        "name":"google",
        "icon":"google-logo",
        "avaliable":false
    ],
    [
        "id":3,
        "name":"heroku",
        "icon":"heroku-logo",
        "avaliable":false
    ],
    [
        "id":4,
        "name":"vmware",
        "icon":"vmware-logo",
        "avaliable":false
    ]
]

let EC2_METRICS = [
    [
        "name":"CPUUtilization",
        "index": 0
    ],
    [
        "name":"NetworkIn",
        "index": 1
    ],
    [
        "name":"NetworkOut",
        "index": 2
    ],
    [
        "name":"DiskReadBytes",
        "index": 3
    ],
    [
        "name":"DiskWriteBytes",
        "index": 4
    ]
]

let EC2_AVERAGE = "Average"
let EC2_MAXIMUM = "Maximum"
let EC2_MINIMUM = "Minimum"

