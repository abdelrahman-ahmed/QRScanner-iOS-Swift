//
//  QRSCannerView.swift
//  QRScanner
//
//  Created by Abdelrahman Ahmed on 5/18/16.
//  Copyright © 2016 Abdelrahman Ahmed. All rights reserved.
//

import UIKit

@IBDesignable
class QRSCannerView: UIView
{

    var margin:CGFloat = 10
    var cornerLength:CGFloat = 30
    var lineWidth:CGFloat = 10
    
    var strokeColor:UIColor = UIColor.greenColor()
    
    private var laserScanLineLayer:CALayer?

    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        strokeColor.setStroke()
        
        addMaskLayer()

        laserScanLineLayer = movingBarLayerWithShadow()

        layer.masksToBounds = true
        layer.addSublayer(laserScanLineLayer!)
    }
    
    
    //MARK:- Remove Laser Scanner Layer
    func removeLaserLayer(){
        laserScanLineLayer?.removeAllAnimations()
        laserScanLineLayer?.removeFromSuperlayer()
    }
    
    //MARK:-
    func addMaskLayer(){
        let path = topLeftMaskPath()
        path.appendPath(topRightMaskPath())
        path.appendPath(bottomRightMaskPath())
        path.appendPath(bottomLeftMaskPath())
        
        path.lineWidth = lineWidth
        path.stroke()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.CGPath
    }
    
    
    //MARK:- 
    func movingBarLayerWithShadow()->CALayer {
        let laserScanLineLayer = CALayer()
        laserScanLineLayer.frame = CGRect(x: margin + lineWidth / 2, y: margin + lineWidth / 2 , width: layer.bounds.width - 2 * margin - lineWidth, height: 2)
        laserScanLineLayer.backgroundColor = UIColor.redColor().CGColor
        
        laserScanLineLayer.masksToBounds = false
        laserScanLineLayer.shadowColor = UIColor.redColor().CGColor
        laserScanLineLayer.shadowOpacity = 0.5
        laserScanLineLayer.shadowOffset = CGSizeMake(0, 0)
        laserScanLineLayer.rasterizationScale =  0.2

        
        laserScanLineLayer.addAnimation(shadowAnimations(laserScanLineLayer.bounds), forKey: "shadowAnimation")
        
        laserScanLineLayer.addAnimation(yPositionAnimation(), forKey: "position.y")

        return laserScanLineLayer
    }
    
    
    //MARK:- Y motion animation
    private func yPositionAnimation()->CAAnimation {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = margin + lineWidth / 2
        animation.toValue = layer.bounds.height - margin - lineWidth / 2
        animation.duration = 2.0
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        return animation
    }
    
    
    
    //MARK: Ahadow animation
    func shadowAnimations(bounds:CGRect)->CAAnimationGroup {
        
        let path1 = UIBezierPath(rect: CGRectMake(0, 0, bounds.width, 0))
        let path2 = UIBezierPath(rect:CGRectMake(0, -100, bounds.width, 100))
        let path3
            = UIBezierPath(rect:CGRectMake(0, 0, bounds.width, 100))

        
        let shadowAnimation1 = shadowAinmationWithPath(path1, shadowPathTo: path2, beginTime: 0.0, duration: 1.0)
        
        let shadowAnimation2 = shadowAinmationWithPath(path2, shadowPathTo: path1, beginTime: 1.0, duration: 1.0)

        let shadowAnimation3 = shadowAinmationWithPath(path1, shadowPathTo: path3, beginTime: 2.0, duration: 1.0)
        
        let shadowAnimation4 = shadowAinmationWithPath(path3, shadowPathTo: path1, beginTime: 3.0, duration: 1.0)

        
        
        let shadowAnimationGroup: CAAnimationGroup = CAAnimationGroup()
        shadowAnimationGroup.animations = [shadowAnimation1, shadowAnimation2, shadowAnimation3, shadowAnimation4]
        shadowAnimationGroup.duration = 4.0
        shadowAnimationGroup.autoreverses = false
        shadowAnimationGroup.repeatCount = Float.infinity
        shadowAnimationGroup.removedOnCompletion = true
        
        return shadowAnimationGroup
    }
    
    func shadowAinmationWithPath(shadowPathFrom:UIBezierPath, shadowPathTo:UIBezierPath, beginTime: CFTimeInterval, duration: CFTimeInterval) -> CABasicAnimation {
        let shadowAnimation = CABasicAnimation(keyPath: "shadowPath")
        shadowAnimation.fromValue = shadowPathFrom.CGPath
        shadowAnimation.toValue = shadowPathTo.CGPath
        shadowAnimation.beginTime = beginTime
        shadowAnimation.duration = duration
        shadowAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return shadowAnimation
    }
    
    //MARK:- Corner pathes
    func topLeftMaskPath()->UIBezierPath {
        let path = UIBezierPath()        
        path.moveToPoint(CGPoint(x: margin, y: margin + cornerLength))
        path.addLineToPoint(CGPoint(x: margin, y: margin))
        path.addLineToPoint(CGPoint(x: cornerLength + margin, y: margin))
        return path
    }
    
    func topRightMaskPath()->UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x:bounds.width - margin - cornerLength, y: margin ))
        path.addLineToPoint(CGPoint(x: bounds.width - margin, y: margin))
        path.addLineToPoint(CGPoint(x: bounds.width - margin, y: margin + cornerLength))
        return path
    }
    
    func bottomRightMaskPath()->UIBezierPath {
        let path = UIBezierPath()
        
        path.moveToPoint(CGPoint(x:margin, y: bounds.height - margin - cornerLength))
        path.addLineToPoint(CGPoint(x: margin, y: bounds.height - margin))
        path.addLineToPoint(CGPoint(x: margin + cornerLength, y: bounds.height - margin))
        return path
    }
    
    func bottomLeftMaskPath()->UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: bounds.width - margin, y: bounds.height - margin - cornerLength))
        path.addLineToPoint(CGPoint(x:  bounds.width - margin, y: bounds.height - margin))
        path.addLineToPoint(CGPoint(x:  bounds.width - margin - cornerLength, y: bounds.height - margin))
        return path
    }

}
