//
//  DismissingAnimationController.swift
//  LolMate
//
//  Created by Sun on 9/17/2560 BE.
//  Copyright © 2560 TCDisrupt. All rights reserved.
//

import UIKit
import pop

class DismissingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view
        toView?.tintAdjustmentMode = UIViewTintAdjustmentMode.normal
        toView?.isUserInteractionEnabled = true;
        
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view
        toView?.frame = CGRect(x: 0, y: 0, width: transitionContext.containerView.bounds.width - 100,
                               height: transitionContext.containerView.bounds.height - 200)

        
        let closeAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        
        closeAnimation?.toValue =  1 - (fromView?.layer.position.y)!
        closeAnimation?.completionBlock = {(animation, finished) in
            transitionContext.completeTransition(true)
        }
        
        let scaleDownAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleDownAnimation?.springBounciness = 20;
        scaleDownAnimation?.fromValue = NSValue(cgPoint: CGPoint(x: 0, y: 0))
        fromView?.layer .pop_add(closeAnimation, forKey: "closeAnimation")
        fromView?.layer.pop_add(scaleDownAnimation, forKey: "scaleAnimation")
        
    }
    
}
