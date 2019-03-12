//
//  CustomPushAnimator.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 31/01/2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import UIKit

final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else {return}
        guard let destination = transitionContext.viewController(forKey: .to) else {return}
        
        let width = source.view.frame.width
        let height = source.view.frame.height

        let initialTranslation = CGAffineTransform(translationX: width / 2 + height / 2, y: -width / 2)
        let initialRotation = CGAffineTransform(rotationAngle: -.pi / 2)
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        destination.view.transform = initialRotation.concatenating(initialTranslation)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0.5, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                let translation = CGAffineTransform(translationX: -width / 2 - height / 2, y: -width / 2)
                let rotation = CGAffineTransform(rotationAngle: .pi / 2)
                source.view.transform = rotation.concatenating(translation)
                
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                destination.view.transform = .identity
                
            })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
