//
//  RKSwipeBetweenViewControllers.m
//  RKSwipeBetweenViewControllers
//
//  Created by Richard Kim on 7/24/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

#import "RKSwipeBetweenViewControllers.h"

//%%% customizeable button attributes
#define X_BUFFER 0 //%%% the number of pixels on either side of the segment
#define Y_BUFFER 14 //%%% number of pixels on top of the segment
#define HEIGHT 30 //%%% height of the segment

//%%% customizeable selector bar attributes (the black bar under the buttons)
#define ANIMATION_SPEED 0.2 //%%% the number of seconds it takes to complete the animation
#define SELECTOR_Y_BUFFER 40 //%%% the y-value of the bar that shows what page you are on (0 is the top)
#define SELECTOR_HEIGHT 4 //%%% thickness of the selector bar

#define X_OFFSET 8 //%%% for some reason there's a little bit of a glitchy offset.  I'm going to look for a better workaround in the future

@interface RKSwipeBetweenViewControllers () {
    UIScrollView *pageScrollView;
    NSInteger currentPageIndex;
}

@end

@implementation RKSwipeBetweenViewControllers
@synthesize viewControllerArray;
@synthesize selectionBar;
@synthesize panGestureRecognizer;
@synthesize manualSelectionBar;
@synthesize pageController;
@synthesize navigationView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISegmentedControl *blah = [[UISegmentedControl alloc]initWithItems:@[@"blah",@"blahblah"]];
    
    self.navigationItem.titleView = blah;
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.01 green:0.05 blue:0.06 alpha:1]; //%%% bartint
    self.navigationBar.translucent = NO;
    viewControllerArray = [[NSMutableArray alloc]init];
    currentPageIndex = 0;
}

//This stuff here is customizeable: buttons, views, etc
////////////////////////////////////////////////////////////
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%    CUSTOMIZEABLE    %%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//

//%%% color of the status bar
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
    
//    return UIStatusBarStyleDefault;
}

//%%% sets up the tabs using a loop.  You can take apart the loop to customize individual buttons, but remember to tag the buttons.  (button.tag=0 and the second button.tag=1, etc)
-(void)setupSegmentButtons
{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.navigationBar.frame.size.height)];
    
    NSInteger numControllers = [viewControllerArray count];
    
    NSArray *buttonText = [[NSArray alloc]initWithObjects: @"first",@"second",@"third",@"fourth",@"etc",@"etc",@"etc",@"etc",nil]; //%%%buttontitle
    
    for (int i = 0; i<numControllers; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER+i*(self.view.frame.size.width-2*X_BUFFER)/numControllers-X_OFFSET, Y_BUFFER, (self.view.frame.size.width-2*X_BUFFER)/numControllers, HEIGHT)];
        [navigationView addSubview:button];
        
        button.tag = i; //%%% IMPORTANT: if you make your own custom buttons, you have to tag them appropriately
        button.backgroundColor = [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1];//%%% buttoncolors
        
        [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitle:[buttonText objectAtIndex:i] forState:UIControlStateNormal]; //%%%buttontitle
    }
    
    pageController.navigationController.navigationBar.topItem.titleView = navigationView;
    
    //%%% example custom buttons example:
    /*
    NSInteger width = (self.view.frame.size.width-(2*X_BUFFER))/3;
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER, Y_BUFFER, width, HEIGHT)];
    UIButton *middleButton = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER+width, Y_BUFFER, width, HEIGHT)];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER+2*width, Y_BUFFER, width, HEIGHT)];
    
    [self.navigationBar addSubview:leftButton];
    [self.navigationBar addSubview:middleButton];
    [self.navigationBar addSubview:rightButton];
    
    leftButton.tag = 0;
    middleButton.tag = 1;
    rightButton.tag = 2;
    
    leftButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1];
    middleButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1];
    rightButton.backgroundColor = [UIColor colorWithRed:0.03 green:0.07 blue:0.08 alpha:1];
    
    [leftButton addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [middleButton addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [leftButton setTitle:@"left" forState:UIControlStateNormal];
    [middleButton setTitle:@"middle" forState:UIControlStateNormal];
    [rightButton setTitle:@"right" forState:UIControlStateNormal];
     */
    
    [self setupSelector];
}


//%%% sets up the selection bar under the buttons on the navigation bar
-(void)setupSelector
{
    selectionBar = [[UIView alloc]initWithFrame:CGRectMake(X_BUFFER-X_OFFSET, SELECTOR_Y_BUFFER,(self.view.frame.size.width-2*X_BUFFER)/[viewControllerArray count], SELECTOR_HEIGHT)];
    selectionBar.backgroundColor = [UIColor greenColor]; //%%% sbcolor
    selectionBar.alpha = 0.8; //%%% sbalpha
    [navigationView addSubview:selectionBar];
    
    manualSelectionBar = [[UIView alloc]initWithFrame:selectionBar.frame];
    manualSelectionBar.backgroundColor = [UIColor greenColor]; //%%% sbcolor (moving)
    manualSelectionBar.alpha = 0.5; //%%% msbalpha
    manualSelectionBar.hidden = YES;
    [self.navigationBar addSubview:manualSelectionBar];
}

//                                                        //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%    CUSTOMIZEABLE    %%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
////////////////////////////////////////////////////////////





//generally, this shouldn't be changed unless you know what you're changing
////////////////////////////////////////////////////////////
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%        SETUP       %%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                                                        //

-(void)viewWillAppear:(BOOL)animated
{
    [self setupPageViewController];
    [self setupSegmentButtons];
}

//%%% generic setup stuff for a pageview controller.  Sets up the scrolling style and delegate for the controller
-(void)setupPageViewController
{
    pageController = (UIPageViewController*)self.topViewController;
    pageController.delegate = self;
    pageController.dataSource = self;
    [pageController setViewControllers:@[[viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self syncScrollView];
}

//%%% this allows us to get information back from the scrollview, namely the coordinate information that we can link to the selection bar.
-(void)syncScrollView
{
    for (UIView* view in pageController.view.subviews){
        if([view isKindOfClass:[UIScrollView class]])
        {
            pageScrollView = (UIScrollView *)view;
            pageScrollView.delegate = self;
        }
    }
}


//%%% when you tap one of the buttons, it shows that page,
//but it also has to animate the other pages to make it feel like you're crossing a 2d expansion,
//so there's a loop that shows every view controller in the array up to the one you selected
//eg: if you're on page 1 and you click tab 3, then it shows you page 2 and then page 3
-(void)tapSegmentButtonAction:(UIButton *)button
{
    selectionBar.hidden = YES;
    manualSelectionBar.frame = selectionBar.frame;
    manualSelectionBar.hidden = NO;
    NSInteger tempIndex = currentPageIndex;
    currentPageIndex = button.tag;
    
    [self animateToIndex:button.tag];
    if (button.tag > tempIndex) {
        for (int i = (int)tempIndex+1; i<=button.tag; i++) {
            [pageController setViewControllers:@[[viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
    } else if (button.tag < tempIndex) {
        for (int i = (int)tempIndex-1; i >= button.tag; i--) {
            [pageController setViewControllers:@[[viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }
    }
}

//%%% This is a safety measure to pull the selector on the the correct tab just in case it goes awry
-(void)settleSelectionBar:(NSInteger)index
{
    NSInteger numPages = [viewControllerArray count];
    NSInteger xCoor = X_BUFFER+((self.view.frame.size.width-2*X_BUFFER)/numPages*index)-X_OFFSET;
    
    [UIView animateWithDuration:ANIMATION_SPEED animations:^{
        selectionBar.frame = CGRectMake(xCoor, selectionBar.frame.origin.y, selectionBar.frame.size.width, selectionBar.frame.size.height);
    }];
}

//%%% when you tap a button, this hides the current selection bar and shows the background bar.
//then, it animages it to the correct page and then shows the correct bar again.
//The reason why there are two bars is because when you tap a button,
//the bar actually glitches out a little bit, so this prevents that
-(void)animateToIndex:(NSInteger)index
{
    NSInteger numPages = [viewControllerArray count];
    NSInteger xCoor = X_BUFFER+((self.view.frame.size.width-2*X_BUFFER)/numPages*index)-X_OFFSET;
    
    [UIView animateWithDuration:ANIMATION_SPEED*2.5 animations:^{
        manualSelectionBar.frame = CGRectMake(xCoor, selectionBar.frame.origin.y, selectionBar.frame.size.width, selectionBar.frame.size.height);
    }
                     completion:^(BOOL finished){
                         selectionBar.frame = manualSelectionBar.frame;
                         selectionBar.hidden = NO;
                         manualSelectionBar.hidden = YES;
                     }];
}

//%%% method is called when any of the pages moves.
//It extracts the xcoordinate from the center point and instructs the selection bar to move accordingly
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat xFromCenter = self.view.frame.size.width-pageScrollView.contentOffset.x; //%%% positive for right swipe, negative for left
    NSInteger xCoor = X_BUFFER+selectionBar.frame.size.width*currentPageIndex -X_OFFSET;
    if (xFromCenter == 0) {
        [self settleSelectionBar:currentPageIndex];
    } else {
        selectionBar.frame = CGRectMake(xCoor-xFromCenter/[viewControllerArray count], selectionBar.frame.origin.y, selectionBar.frame.size.width, selectionBar.frame.size.height);
    }
}

//%%% checks to see which item we are currently looking at from the array of view controllers
-(NSInteger)indexOfController:(UIViewController *)viewController
{
    for (int i = 0; i<[viewControllerArray count]; i++) {
        if (viewController == [viewControllerArray objectAtIndex:i])
        {
            return i;
        }
    }
    return NSNotFound;
}


//                                                        //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%        SETUP       %%%%%%%%%%%%%%%%%%//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
////////////////////////////////////////////////////////////




//%%% the delegate functions for UIPageViewController.
//Pretty standard, but generally, don't touch this.
////////////////////////////////////////////////////////////
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//%%%%%%       UIPageViewController Delegate       %%%%%%%//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfController:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    index--;
    return [viewControllerArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfController:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [viewControllerArray count]) {
        return nil;
    }
    return [viewControllerArray objectAtIndex:index];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        currentPageIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
    }
}

//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//%%%%%%       UIPageViewController Delegate       %%%%%%%//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
////////////////////////////////////////////////////////////

@end
