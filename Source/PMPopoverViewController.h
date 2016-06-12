//
//  PMPopoverViewController.h
//
//  Created by Paperman on 12.06.16.
//  Copyright (c) 2016 Paperman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMPopoverViewController;
@protocol ARSPopoverDelegate <NSObject>

@optional

/*!
 Popover notifies the delegate, that the popover needs to reposition it's location.
 */
- (void)popoverViewController:(PMPopoverViewController *)popoverViewController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view;

/*!
 Popover asks the delegate, whether it should dismiss itself.
 */
- (BOOL)popoverViewControllerShouldDismissPopover:(PMPopoverViewController *)popoverViewController;

/*!
 Popover notifies the delegate, that popover did dismiss itself.
 */
- (void)popoverViewControllerDidDismissPopover:(PMPopoverViewController *)popoverViewController;

@end

@interface PMPopoverViewController : UIViewController

- (instancetype)initWithContentViewController:(UIViewController *)viewController;

/// Popover's delegate.
@property (nonatomic, weak) id<ARSPopoverDelegate> delegate;

/// The preferred size for the popover’s view.
@property (nonatomic, assign) CGSize popoverContentSize;

/// The color of the popover’s backdrop view.
@property (nonatomic, strong) UIColor *backgroundColor;

/// Use this property to configure where popover's arrow should be pointing.
@property (nonatomic, assign) UIPopoverArrowDirection popoverArrowDirection;

/// An array of views that the user can interact with while the popover is visible.
@property (nonatomic, strong) NSArray *passthroughViews;

///The margins that define the portion of the screen in which it is permissible to display the popover.
@property (nonatomic, assign) UIEdgeInsets popoverLayoutMargins;

- (void)showPopoverInViewController:(UIViewController *)viewController fromRect:(CGRect)rect inView:(UIView *)view;
- (void)showPopoverInViewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem *)item;

- (void)dismissPopover;

@end