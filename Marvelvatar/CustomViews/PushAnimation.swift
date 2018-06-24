//
//  PushAnimation.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 9/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit

class PushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.2
    var isPresenting = true
    var originFrame = CGRect.zero
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = isPresenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = isPresenting ? originFrame : fromView.frame
        let finalFrame = isPresenting ? fromView.frame : originFrame
        
        let xScaleFactor = isPresenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = isPresenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if isPresenting {
            fromView.transform = scaleTransform
            fromView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            fromView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: fromView)
        
        UIView.animate(withDuration: duration, delay:0.1,
                       usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,
                       animations: {
                        fromView.transform = self.isPresenting ? CGAffineTransform.identity : scaleTransform
                        fromView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                        
                        
                        if !self.isPresenting {
                            UIView.transition(from: fromView, to: toView, duration: 0, options: .transitionCurlUp, completion: nil)
                            
                        }
                        
        }, completion: { _ in
            
            transitionContext.completeTransition(true)
        })
    }
}
