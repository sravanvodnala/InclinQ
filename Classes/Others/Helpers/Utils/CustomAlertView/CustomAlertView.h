//
//  CustomAlertView.h
//  CustomAlertView
//
//  Created by Rahul Shirphule on 21/05/14.
//  Copyright (c) 2014 Wimagguc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAlertViewDelegate

- (void)customdialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CustomAlertView : UIView<CustomAlertViewDelegate>

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)
@property (nonatomic, retain) UIView *buttonView;    // Buttons on the bottom of the dialog

@property (nonatomic, assign) id<CustomAlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;

@property (copy) void (^onButtonTouchUpInside)(CustomAlertView *alertView, int buttonIndex) ;

- (id)init;

///*!
// DEPRECATED: Use the [CustomAlertView init] method without passing a parent view.
// */
//- (id)initWithParentView: (UIView *)_parentView __attribute__ ((deprecated));

- (void)show;
- (void)close;

//- (IBAction)customdialogButtonTouchUpInside:(id)sender;
- (void)setOnButtonTouchUpInside:(void (^)(CustomAlertView *alertView, int buttonIndex))onButtonTouchUpInside;

- (void)deviceOrientationDidChange: (NSNotification *)notification;

@end