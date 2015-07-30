//
//  ViewController.swift
//  SurpriseSelfie
//
//  Created by Adam Reis on 7/2/15.
//  Copyright (c) 2015 Adam Reis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let previewView = UIView(frame: self.view.frame)
        previewView.backgroundColor = UIColor.blackColor()
        let previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.frame = previewView.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewView.layer.addSublayer(previewLayer)
        self.view.addSubview(previewView)
        self.view.sendSubviewToBack(previewView)

        
        let vision = PBJVision.sharedInstance()
        vision.delegate = self
        vision.cameraMode = .Photo
        vision.cameraOrientation = .Portrait
        vision.focusMode = .ContinuousAutoFocus
        vision.outputFormat = PBJOutputFormat.Standard
        vision.captureSessionPreset = AVCaptureSessionPresetHigh
        vision.startPreview()
        
    }

    @IBAction func photoButtonTapped(sender: AnyObject) {
        let vision = PBJVision.sharedInstance()
        vision.capturePhoto()
    }

}

extension ViewController: PBJVisionDelegate {
    func vision(vision: PBJVision, capturedPhoto photoDict: [NSObject : AnyObject]?, error: NSError?) {
// TODO: handle errors
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            let imageData: NSData = photoDict![PBJVisionPhotoJPEGKey] as! NSData
            let image = UIImage(data: imageData)
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        })
        
        vision.startPreview()
    }
}