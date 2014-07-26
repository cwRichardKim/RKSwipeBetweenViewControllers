//
//  RKScrollingSegmentedControl.h
//  RKScrollingSegmentedControl
//
//  Created by Richard Kim on 7/24/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

/*
 TABLE OF CONTENTS
 If you want to customize something, look for what you want on the left and then search (cmd+shift+"f") for the term on the right.
 
 customizeable item                       Search Term
 - selector bar color                   sbcolor
 - selector bar alpha                   sbalpha
 - moving selector bar alpha            msbalpha
 - selector bar bounce animation        BOUNCE_BUFFER
 - selector bar animation speed         ANIMATION_SPEED
 - selector bar further customization   top of the .m (multiple attributes
 - button colors                        buttoncolors
 - button text                          buttontext
 - further button customization         top of the .m (multiple attributes)
 - individual button customization      customb
 - bar tint color                       bartint
 
 want anything anything else? Feel free to contact me at cwrichardkim@gmail.com
 
 */


@protocol RKScrollingSegmentedControlDelegate <NSObject>

@end

#import <UIKit/UIKit.h>



@interface RKScrollingSegmentedControl : UINavigationController <UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic, weak) id<RKScrollingSegmentedControlDelegate> navDelegate;
@property (nonatomic, strong) UIView *selectionBar;
@property (nonatomic, strong) UIView *manualSelectionBar;
@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;

@end
