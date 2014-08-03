//
//  RKSwipeBetweenViewControllers.h
//  RKSwipeBetweenViewControllers
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
 
 @cwRichardKim for regular updates / requests
 
 customizeable item                       Search Term
 - selector bar color                   sbcolor
 - selector bar alpha                   sbalpha
 - moving selector bar alpha            msbalpha
 - selector bar animation speed         ANIMATION_SPEED
 - selector bar further customization   top of the .m (multiple attributes
 - button colors                        buttoncolors
 - button text                          buttontext
 - further button customization         top of the .m (multiple attributes)
 - individual button customization      customb
 - bar tint color                       bartint
 - speed up / prevent lag               (see explanation in "how this works" below)
 - further customization                see "how this works" below
 
 want anything anything else? Feel free to contact me at cwrichardkim@gmail.com
 
 */


/* HOW THIS WORKS
 In order to encourage customization, I'm going to try to describe exactly how it works
 
- Design/Build
     RKSwipeBetweenViewControllers is a custom UINavigationController
     with UIButtons as tabs and a UIView as the slider that moves around
     
     The class builds a standard UIPageViewController with the 
     controllers in "viewControllerArray" and dynamically adjusts the 
     buttons according to how many objects there are. (i.e. if there are 
     2 controllers, there will be 2 tabs, and the slider will be 
     width/2-buffer/2 wide)
     
     The buttons are automatically placed evenly across the navigation bar, 
     but you can adjust placement and size with the x/y buffers or the
     height of the buttons
 
 
- Swiping
    - Correct ViewController
     Swiping between pages calls the delegate functions:
     (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
        viewControllerBeforeViewController:(UIViewController *)viewController
     
     and
     
     (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
        viewControllerAfterViewController:(UIViewController *)viewController
     
     These are actually not as intuitive as you would think, because if you 
     swipe once, it calls both functions so that it can build and maintain 
     the pages (i think). This means it isn't a simple solution of "get me the 
     next page", you have to check what page you are on and then return that 
     page from the viewControllerArray
     
     So, this is possible by maintaining a "currentPageIndex".  Whenever the 
     user calls a swipe command, the delegate function
     
     (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating
        (BOOL)finished previousViewControllers:(NSArray *)previousViewControllers 
        transitionCompleted:(BOOL)completed
     
     is called, and here I check to see if the action is completed 
     (you can stop mid-swipe and swipe back), and then check the index 
     of the page i'm on.
 
    - Moving the Selector / Slider
     In the function "syncScrollView", I grab the UIPageViewController's
     UIScrollView, and then I set the delegate to this custom class
     
     So, whenever you move the pages, 
     (void)scrollViewDidScroll:(UIScrollView *)scrollView is called.
     Here I can measure how far you are moving the page with "xFromCenter"
     and then adjust the UIView for the slider accordingly
 
 
- Tapping Tabs
    - Changing Pages
     I've set up the buttons so that they each have a tag number (left = 0).
     And I've attached the function "tapSegmentButtonAction" to each button
     So, when you tap a button, it checks the tag, and that's the index of
     the controller you want in the viewControllerArray.  But, if it jumped
     straight to it, you wouldn't get an understanding of the pages in between
     and it wouldn't feel right.  So, I've constructed a loop that shows every
     controller in viewControllerArray from where you are to where you have to
     go.
 
    - Moving the Slider
     Unfortunately, I've found that because I grabbed the UIScrollView's 
     delegate, whenever I move the scroll view for anything, it moves 
     the slider.  Which means, whenever I change the pages programmatically,
     it also adjusts the slider.  This becomes really janky and stuttery
     when you're dealing with multiple view controllers, and it jumps around
     because it can't tell the difference between two pages very well
 
     So, I've constructed another slider called "manualSelectionBar" that
     moves instead.  You can see this when you click, the bar gets darker.
     I've added that intentionally, but you can remove that by going to 
     "msbalpha".  So, when you tap one of the tabs, the current slider
     that's connected to the UIScrollView hides, and the background slider
     shows up.  Then, it moves appropriately, and switches places again.
     This way you can also control the speed of the slider's movement
 
     However, this does mean that if you tap a tab and then stop the
     movement manually, it does something a little weird.
 
- Lag when you first swipe through your view controllers
     The reason this happens is because of the way UIPageViewController works.
     I actually implemented my own custom class, but realized it would get
     more confusing, and require people to spend more time learning how to use
     this, so I got rid of it.  
 
     So, when you use a UIPageViewController and you swipe, it builds the
     entire controller and then shows it to you.  That means if you have
     a UITableViewController, it has to build the first x number of cells.
     If you have photos or lots of data, this can take a while.
 
     The primary way to get around this is to run all of your custom setup
     in the background.  There are tons of ways and tons of tutorials on this
     already, so I won't get into detail.
 */

@protocol RKSwipeBetweenViewControllersDelegate <NSObject>

@end

#import <UIKit/UIKit.h>



@interface RKSwipeBetweenViewControllers : UINavigationController <UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic, weak) id<RKSwipeBetweenViewControllersDelegate> navDelegate;
@property (nonatomic, strong) UIView *selectionBar;
@property (nonatomic, strong) UIView *manualSelectionBar;
@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong)UIPageViewController *pageController;
@property (nonatomic, strong)UIView *navigationView;
@property (nonatomic, strong)NSArray *buttonText;

@end
