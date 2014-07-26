//
//  RKScrollingSegmentedControl.h
//  RKScrollingSegmentedControl
//
//  Created by Richard Kim on 7/24/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

/*
 
 Copyright (c) 2014 Choong-Won Richard Kim <cwrichardkim@gmail.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */


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
