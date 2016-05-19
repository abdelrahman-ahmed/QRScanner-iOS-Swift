//
//  ViewController.swift
//  QRScanner
//
//  Created by Abdelrahman Ahmed on 5/18/16.
//  Copyright © 2016 Abdelrahman Ahmed. All rights reserved.
//

import UIKit

import AVFoundation
import UIKit


protocol QRScannerViewControllerDelegate:class {
    func codeDidFound(code: String)
    func didFail()
    func didCancel()
    func isValidCode()->Bool
}



class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var containerView: UIView = UIView()
    
    var headerView =  UIView()
    var footerView =  UIView()
    
    var scannerOverlayView: QRSCannerView =  QRSCannerView()
    var notesLabel: UILabel =  UILabel()
    var cancelButton: UIButton =  UIButton()
    
    var note:String? = "Scan QR"
    
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate:QRScannerViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpContainerView()
        setupQROverlayView()
        setupHeaderView()
        setupFooterView()
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[headerView(==40)][scannerOverlayView][footerView(==30)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scannerOverlayView" : scannerOverlayView, "headerView" : headerView, "footerView" : footerView]))
        
        
        
        
        view.backgroundColor = UIColor.blackColor()
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            failed()
            return
        }
        
        setupPreviewLayer()
        captureSession.startRunning()
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning()
        }
    }
    
    
    
    //MARK:-
    func setUpContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
    }
    
    func setupQROverlayView() {
        scannerOverlayView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scannerOverlayView)
        scannerOverlayView.backgroundColor = UIColor.clearColor()
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scannerOverlayView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scannerOverlayView" : scannerOverlayView]))
    }
    
    func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        headerView.backgroundColor = UIColor.lightGrayColor()
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[headerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["headerView" : headerView]))
        setupButtons()
    }
    
    func setupFooterView() {
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(footerView)
        footerView.backgroundColor = UIColor.lightGrayColor()
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[footerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["footerView" : footerView]))
        
        setupNotesLabel()
    }
    
    
    func setupButtons() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", forState: .Normal)
        
        cancelButton.addTarget(self, action: #selector(cancel), forControlEvents: .TouchUpInside)
        headerView.addSubview(cancelButton)
        
        headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[cancelButton]->=8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["cancelButton":cancelButton]))
        
        headerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cancelButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views:["cancelButton":cancelButton]))
        
    }
    
    
    func setupNotesLabel(){
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(notesLabel)
        notesLabel.text = note
        notesLabel.textAlignment = .Center
        notesLabel.textColor = UIColor.whiteColor()
        
        footerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[notesLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["notesLabel" : notesLabel]))
        
        footerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[notesLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["notesLabel" : notesLabel]))
    }
    
    
    func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        containerView.layer.addSublayer(previewLayer)
    }
    
    
    //MARK:- Cancel action
    func cancel()  {
        print("cancelled")
        dismissViewControllerAnimated(true) {[weak self] in
            self?.delegate?.didCancel()
        }
    }
    
    
    //MARK:-
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue)
        }
        
    }
    
    
    //MARK:-
    func foundCode(code: String) {
        print(code)
        scannerOverlayView.removeLaserLayer()
        
        if delegate?.isValidCode() == true {
            delegate?.codeDidFound(code)
        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .Default) {[weak self] _ in
            self?.delegate?.didFail()
        }
        
        ac.addAction(alertAction)
        
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
}