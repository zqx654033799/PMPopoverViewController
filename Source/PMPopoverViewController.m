//
//  PMPopoverViewController.m
//
//  Created by Paperman on 12.06.16.
//  Copyright (c) 2016 Paperman. All rights reserved.
//

#import "PMPopoverViewController.h"

@interface UIPopoverController (overrides)
+ (BOOL)_popoversDisabled;
@end
@implementation UIPopoverController (Popover)
+(BOOL)_popoversDisabled {
    return NO;
}
@end

@interface PMPopoverViewController ()
@property (nonatomic, weak) UIView *sourceView;
@property (nonatomic, assign) CGRect sourceRect;

@property (nonatomic, strong) UIViewController *popoverContentViewController;
@property (nonatomic, strong) UIPopoverController *popoverController;
@end
@implementation PMPopoverViewController
- (instancetype)initWithContentViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.popoverArrowDirection = UIPopoverArrowDirectionAny;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            self.modalPresentationStyle = UIModalPresentationPopover;
            self.popoverPresentationController.delegate = (id)self;
            self.popoverContentViewController = viewController;
        } else {
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
            self.popoverController.delegate = (id)self;
        }
    }
    return self;
}

#pragma mark - Actions
- (void)showPopoverInViewController:(UIViewController *)viewController fromRect:(CGRect)rect inView:(UIView *)view {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        self.popoverPresentationController.sourceView = view;
        self.popoverPresentationController.sourceRect = rect;
        [self showPopoverInViewController:viewController];
    } else {
        [self showPopoverInViewController:viewController];
        [self.popoverController presentPopoverFromRect:rect inView:view permittedArrowDirections:self.popoverArrowDirection animated:YES];
    }
}

- (void)showPopoverInViewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem *)item {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        self.popoverPresentationController.barButtonItem = item;
        [self showPopoverInViewController:viewController];
    } else {
        [self showPopoverInViewController:viewController];
        [self.popoverController presentPopoverFromBarButtonItem:item permittedArrowDirections:self.popoverArrowDirection animated:YES];
    }
}

- (void)showPopoverInViewController:(UIViewController *)viewController {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        self.preferredContentSize = self.popoverContentSize;
        self.popoverPresentationController.permittedArrowDirections = self.popoverArrowDirection;
        self.popoverPresentationController.passthroughViews = self.passthroughViews;
        self.popoverPresentationController.backgroundColor = self.backgroundColor;
        self.popoverPresentationController.popoverLayoutMargins = self.popoverLayoutMargins;
        [viewController presentViewController:self animated:YES completion:^{
            CGFloat presentationArrowHeight = 12.0;
            CGFloat width = CGRectGetWidth(self.popoverPresentationController.frameOfPresentedViewInContainerView);
            CGFloat height = CGRectGetHeight(self.popoverPresentationController.frameOfPresentedViewInContainerView) - presentationArrowHeight;
            
            CGRect frame = CGRectMake(0, 0, width, height);
            UIView *contentView = self.popoverContentViewController.view;
            [self.view addSubview:contentView];
            contentView.frame = frame;
        }];
    } else {
        self.popoverController.popoverContentSize = self.popoverContentSize;
        self.popoverController.passthroughViews = self.passthroughViews;
        self.popoverController.backgroundColor = self.backgroundColor;
        self.popoverController.popoverLayoutMargins = self.popoverLayoutMargins;
    }
}

- (void)dismissPopover {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.popoverController dismissPopoverAnimated:YES];
    }
}

#pragma mark - UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    if ([self.delegate respondsToSelector:@selector(popoverPresentationControllerShouldDismissPopover:)]) {
        return [self.delegate popoverViewControllerShouldDismissPopover:self];
    }
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if ([self.delegate respondsToSelector:@selector(popoverPresentationControllerDidDismissPopover:)]) {
        [self.delegate popoverViewControllerDidDismissPopover:self];
    }
}

- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView * __nonnull * __nonnull)view {
    if ([self.delegate respondsToSelector:@selector(popoverPresentationController:willRepositionPopoverToRect:inView:)]) {
        [self.delegate popoverViewController:self willRepositionPopoverToRect:rect inView:view];
    }
}

#pragma mark - UIPopoverPresentationControllerDelegate
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    if ([self.delegate respondsToSelector:@selector(popoverPresentationControllerShouldDismissPopover:)]) {
        return [self.delegate popoverViewControllerShouldDismissPopover:self];
    }
    return YES;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    if ([self.delegate respondsToSelector:@selector(popoverPresentationControllerDidDismissPopover:)]) {
        [self.delegate popoverViewControllerDidDismissPopover:self];
    }
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view {
    if ([self.delegate respondsToSelector:@selector(popoverPresentationController:willRepositionPopoverToRect:inView:)]) {
        [self.delegate popoverViewController:self willRepositionPopoverToRect:rect inView:view];
    }
}

#pragma mark - Adaptive Presentation Controller Delegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    // This method is called in iOS 8.3 or later regardless of trait collection, in which case use the original presentation style (UIModalPresentationNone signals no adaptation)
    return UIModalPresentationNone;
}
@end