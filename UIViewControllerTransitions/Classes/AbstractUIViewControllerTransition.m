//
//  AbstractUIViewControllerTransition.m
//  UIViewControllerTransitions
//
//  Created by Steve Kim on 5/12/16.
//  Modified by Steve Kim on 4/14/17.
//      - Renew design and add new feature interactive transition
//
//

#import "AbstractUIViewControllerTransition.h"
#import "AnimatedTransitioning.h"
#import "PanningInteractiveTransition.h"
#import "UIViewControllerTransitionsMacro.h"
#import <objc/runtime.h>

@interface AbstractUIViewControllerTransition () <UIGestureRecognizerDelegate>
@end

@implementation AbstractUIViewControllerTransition

#pragma mark - Overridden: NSObject

- (void)dealloc {
}

- (id)init {
    self = [super init];
    
    if (self) {
        [self initProperties];
    }
    
    return self;
}

#pragma mark - Properties

- (void)setDismissionInteractor:(AbstractInteractiveTransition *)dismissionInteractor {
    if ([dismissionInteractor isEqual:_dismissionInteractor]) {
        return;
    }
    
    _dismissionInteractor = dismissionInteractor;
    
    if ([dismissionInteractor isKindOfClass:[PanningInteractiveTransition class]]) {
        ((PanningInteractiveTransition *) dismissionInteractor).gestureRecognizer.delegate = self;
    }
}

- (void)setPresentingInteractor:(AbstractInteractiveTransition *)presentingInteractor {
    if ([presentingInteractor isEqual:_presentingInteractor]) {
        return;
    }
    
    _presentingInteractor = presentingInteractor;
    
    if ([presentingInteractor isKindOfClass:[PanningInteractiveTransition class]]) {
        ((PanningInteractiveTransition *) presentingInteractor).gestureRecognizer.delegate = self;
    }
}

#pragma mark - Public methods

- (id)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    
    if (self) {
        [self initProperties];
        
        _viewController = viewController;
    }
    
    return self;
}

#pragma mark - UIViewControllerTransitioning delegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _transitioning = [self animatedTransitioningForDismissedController:dismissed];
    return _transitioning;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _transitioning = [self animatedTransitioningForForPresentedController:presented presentingController:presenting sourceController:source];
    return _transitioning;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return (_allowsInteraction && _interactionEnabled) ? _dismissionInteractor : nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return (_allowsInteraction && _interactionEnabled) ? _presentingInteractor : nil;
}

- (void)setViewController:(UIViewController *)viewController {
    if ([viewController isEqual:_viewController]) {
        return;
    }
    
    _viewController = viewController;
    _viewController.transitioningDelegate = self;
    _viewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [_dismissionInteractor attach:_viewController presentViewController:nil];
}

#pragma mark - UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (!_allowsInteraction) {
        return NO;
    }
    
    if ([_interactionDataSource respondsToSelector:@selector(shouldReceiveTouchWithGestureRecognizer:touch:)]) {
        return [_interactionDataSource shouldReceiveTouchWithGestureRecognizer:gestureRecognizer touch:touch];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (!_allowsInteraction) {
        return NO;
    }
    
    if ([_interactionDataSource respondsToSelector:@selector(shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [_interactionDataSource shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}

#pragma mark - Public methods

- (void)interactiveTransitionBegan:(AbstractInteractiveTransition * _Nonnull)interactor {
    [_transitioning interactionBegan:interactor];
    [_interactionDelegate didBeginTransitioning];
}

- (void)interactiveTransitionCancelled:(AbstractInteractiveTransition * _Nonnull)interactor  completion:(void (^_Nullable)(void))completion {
    [_transitioning interactionCancelled:interactor completion:^{
        [_interactionDelegate didEndTransitioning];
        completion();
    }];
}

- (void)interactiveTransitionChanged:(AbstractInteractiveTransition * _Nonnull)interactor percent:(CGFloat)percent {
    [_transitioning interactionChanged:interactor percent:percent];
    [_interactionDelegate didChangeTransitioning:percent];
}

- (void)interactiveTransitionCompleted:(AbstractInteractiveTransition * _Nonnull)interactor completion:(void (^_Nullable)(void))completion {
    [_transitioning interactionCompleted:interactor completion:^{
        [_interactionDelegate didEndTransitioning];
        completion();
    }];
}

#pragma mark - Protected methods

- (AnimatedTransitioning *)animatedTransitioningForDismissedController:(UIViewController *)dismissed {
    return nil;
}

- (AnimatedTransitioning *)animatedTransitioningForForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return nil;
}

- (void)initProperties {
    _bounceHeight = 100;
    _durationForDismission = _durationForPresenting = 0.6;
    self.dismissionInteractor = [PanningInteractiveTransition new];
    self.presentingInteractor = [PanningInteractiveTransition new];
}

#pragma mark - Private methods

- (void)clear {
    _transitioning = nil;
}

@end

@implementation UIViewController (UIViewControllerTransitions)

- (void)setTransition:(AbstractUIViewControllerTransition *)transition {
    if ([transition isEqual:[self transition]])
        return;
    
    transition.viewController = self;
    
    objc_setAssociatedObject(self, @"transition", transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AbstractUIViewControllerTransition *)transition {
    return objc_getAssociatedObject(self, @"transition");
}

@end
