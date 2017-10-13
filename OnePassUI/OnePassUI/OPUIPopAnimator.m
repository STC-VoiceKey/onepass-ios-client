//
//  OPUIPopAnimator.m
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 11.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIPopAnimator.h"

@implementation OPUIPopAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGFloat screenWidth  = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    
    toViewController.view.frame   = CGRectMake(-screenWidth, 0, screenWidth, screenHeight);
    fromViewController.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);

    [transitionContext.containerView addSubview:toViewController.view];
    [transitionContext.containerView addSubview:fromViewController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.frame = CGRectOffset(fromViewController.view.frame , screenWidth, 0);
        toViewController.view.frame   = CGRectOffset(toViewController.view.frame   , screenWidth, 0);
    }
                     completion:^(BOOL finished){
         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
