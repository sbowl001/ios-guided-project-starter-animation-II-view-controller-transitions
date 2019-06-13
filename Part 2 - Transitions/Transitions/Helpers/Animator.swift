//
//  Animator.swift
//  Transitions
//
//  Created by Stephanie Bowles on 6/13/19.
//  Copyright © 2019 Spencer Curtis. All rights reserved.
//

import UIKit
typealias LabelProvidingVC = LabelProviding & UIViewController


class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
       // how long should your transition run?
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Label is what is going to be animated
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? LabelProvidingVC,
        let toVC = transitionContext.viewController(forKey: .to) as? LabelProvidingVC,
            let toView = transitionContext.view(forKey: .to) else {return}
        //this is the view that holds the label we will animate from one position to the other
        let containerView = transitionContext.containerView
        
        // Get the final frame when the animation is done
        let toViewEndFrame  = transitionContext.finalFrame(for: toVC)
        
        //set up the final Frame
        containerView.addSubview(toView)
        toView.frame = toViewEndFrame
        toView.alpha = 0
        
        //Figure out where the label should start and where it should end up
        
        let fromLabel = fromVC.label!
        let toLabel = toVC.label!
        
        //Hide our Real Labels so they don't show up durign the transition
        fromLabel.alpha = 0
        toLabel.alpha = 0
        
        
        //set up initial frame
        let transitionLabelInitialframe = containerView.convert(fromLabel.bounds, from: fromLabel)
        
        //the transitioning label will be in exactly the same initial location as the fromLabel.
        let transitioningLabel = UILabel(frame: transitionLabelInitialframe)
        transitioningLabel.textColor = .white
        transitioningLabel.font = fromLabel.font
        transitioningLabel.text = fromLabel.text
        containerView.addSubview(transitioningLabel)
        
        // Get our duration from the func transitionDuration
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        toView.layoutIfNeeded()
        
        //perform animation
        UIView.animate(withDuration: transitionDuration, animations: {
            let transitioningLabelEndFrame = containerView.convert(toLabel.bounds, from: toLabel)
            transitioningLabel.frame = transitioningLabelEndFrame
            toView.alpha = 1
        }) { (_) in
            toLabel.alpha = 1
            fromLabel.alpha = 1
            transitioningLabel.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
}


