//
//  OCRCameraViewController.swift
//  vmwatch
//
//  Created by Tuo Zhang on 2016-12-13.
//  Copyright © 2016 ECE496. All rights reserved.
//

import UIKit

class OCRCameraViewController: UIViewController, G8TesseractDelegate {

    var camera = LLSimpleCamera()
    var tesseract:G8Tesseract!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeOCR(){
        tesseract = G8Tesseract(language:"eng")
        tesseract.delegate = self
        tesseract.charWhitelist = "01234567890"
    }
    
    func recongnizeImage(name:String){
        tesseract.image = UIImage(named: name)
        
        if(tesseract.recognize()){
            NSLog("%@", tesseract.recognizedText)
        }
    }
    
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        return false
    }
    
}
