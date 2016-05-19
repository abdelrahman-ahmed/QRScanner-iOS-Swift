//
//  ViewController.swift
//  QRScanner
//
//  Created by Abdelrahman Ahmed on 5/19/16.
//  Copyright © 2016 Abdelrahman Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QRScannerViewControllerDelegate
{

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func scanQR(sender:UIButton){
        let vc = ScannerViewController()
        vc.modalTransitionStyle = .FlipHorizontal
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
    //MARK:- QRScannerViewControllerDelegate
    func codeDidFound(code: String) {
        print(code)
    }
    
    func didFail() {
        print("Failed")
    }
    
    func didCancel() {
        print("Cancelled")
    }
    
    func isValidCode()->Bool {
        return true
    }

}
