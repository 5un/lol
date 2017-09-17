//
//  PresentingAnimationController.swift
//  LolMate
//
//  Created by Sun on 9/17/2560 BE.
//  Copyright © 2560 TCDisrupt. All rights reserved.
//

import UIKit
import pop

class PresentingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view
        fromView?.tintAdjustmentMode = UIViewTintAdjustmentMode.dimmed
        fromView?.isUserInteractionEnabled = false;
        
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view
        toView?.frame = CGRect(x: 0, y: 0, width: transitionContext.containerView.bounds.width - 100,
                               height: transitionContext.containerView.bounds.height - 200)
        
        let p = CGPoint(x: transitionContext.containerView.center.x, y: -transitionContext.containerView.center.y)
        toView?.center = p
        
        transitionContext.containerView.addSubview(toView!)
        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        
        positionAnimation?.toValue = transitionContext.containerView.center.y
        positionAnimation?.springBounciness = 10
        positionAnimation?.completionBlock = {(animation, finished) in
            transitionContext.completeTransition(true)
        }
        
        let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation?.springBounciness = 20;
        scaleAnimation?.fromValue = NSValue(cgPoint: CGPoint(x: 1.2, y: 2.4))
        toView?.layer .pop_add(positionAnimation, forKey: "positionAnimation")
        toView?.layer.pop_add(scaleAnimation, forKey: "scaleAnimation")
        
        
        
        
    }
    
}
