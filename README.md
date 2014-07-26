RKScrollingSegmentedControl
===========================

UIPageViewController and custom UISegmentedControl synchronized and animated.  Similar to Spotify's "My Music" section.

In Progress: a CocoaPod version

## Demo (what you get): 
Don't worry about the colors or the ugly buttons, it's easy to change that to suit your own preferences.  I just kept colors to make it clear what's happening

![demo](http://i.imgur.com/sfjGYcr.gif)


## Dynamic (add your controllers and it will adapt):
![Dynamic](http://i.imgur.com/QeKGdqJ.gif)


## Customizeable!:
![Customizeable](http://i.imgur.com/dl422EL.gif)

check the RKScrollingSegmentedControl.h for more customizeable features

## how to use 
(check out the provided AppDelegate to see an example):

__Programmatically__

1. Import RKScrollingSegmentedControl.h

2. Initialize a UIPageViewController
	
	```
	UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
	```
3. Initialize a RKScrollingSegmentedControl

  	```
	RKScrollingSegmentedControl *navigationController = [[RKScrollingSegmentedControl alloc]initWithRootViewController:pageController];
	```
4. Add all your ViewControllers (in order) to navigationController.viewControllerArray (try to keep it under 5)
  	
	```
	[navigationController.viewControllerArray addObjectsFromArray:@[viewController1, viewController2, viewController3]];
	```
5. Use the custom class (or call it as the first controller from app delegate: see below)
  	
	```
  	self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  	self.window.rootViewController = navigationController;
  	[self.window makeKeyAndVisible];
  	```
  
__StoryBoard__

1. Embed a UIPageViewController inside a UINavigationController.  Change the class of the to UINavigationController the custom class (RKScrollingSegmentedControl)

2. add your viewcontrollers to viewControllerArray like in step 4 (above)



Any problems/questions? shoot me a pm


