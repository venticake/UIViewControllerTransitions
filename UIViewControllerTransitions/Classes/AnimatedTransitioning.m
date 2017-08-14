//
//  AnimatedTransitioning.m
//  UIViewControllerTransitions
//
//  Created by Steve Kim on 5/12/16.
//  Modified by Steve Kim on 4/14/17.
//      - Renew design and add new feature interactive transition
//  Modified by Steve Kim on 8/14/17.
//      - Refactoring design for 3.0.0
//

#import "AnimatedTransitioning.h"
#import "UIViewControllerTransition.h"
#import "UIViewController+UIViewControllerTransitions.h"

@implementation AnimatedTransitioning

#pragma mark - Overridden: AbstractAnimatedTransitioning

- (UIViewController *)aboveViewController {
    return _presenting ? self.toViewController : self.fromViewController;
}

- (UIViewController *)belowViewController {
    return _presenting ? self.fromViewController : self.toViewController;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [super animateTransition:transitionContext];
    
    if (_presenting) {
        [self animateTransitionForPresenting:transitionContext];
    } else {
        [self animateTransitionForDismission:transitionContext];
    }
}

- (void)clear {
    [super clear];
    
    [self.fromViewController beginAppearanceTransition:YES animated:NO];
    [self.toViewController.view removeFromSuperview];
    [self.fromViewController endAppearanceTransition];
}

#pragma mark - Protected methods

- (void)animateTransitionForDismission:(id<UIViewControllerContextTransitioning>)transitionContext {
}

- (void)animateTransitionForPresenting:(id<UIViewControllerContextTransitioning>)transitionContext {
}

@end
