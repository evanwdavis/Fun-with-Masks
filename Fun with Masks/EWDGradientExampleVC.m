//
//  EWDFirstViewController.m
//  Fun with Masks
//
//  Created by Evan Davis on 2/8/13.
//  Copyright (c) 2013 Evan Davis. All rights reserved.
//

#import "EWDGradientExampleVC.h"
#import <QuartzCore/QuartzCore.h>

@interface EWDGradientExampleVC ()

@end

@implementation EWDGradientExampleVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Gradient";
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pw_maze_white"]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, CGRectGetWidth(self.view.bounds) - 10.0f, CGRectGetHeight(self.view.bounds) - 10.0f)];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImageView *bigImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jerusalempano2.jpg"]];
    bigImage.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(scrollView.bounds) * 4, CGRectGetHeight(scrollView.bounds));
    bigImage.contentMode = UIViewContentModeScaleAspectFill;
    bigImage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [scrollView addSubview:bigImage];
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(bigImage.bounds), CGRectGetHeight(scrollView.bounds) - 49.0f)];
    
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [containerView addSubview:scrollView];
    
    [self.view addSubview:containerView];
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.startPoint = CGPointMake(0.3f, 1.0f);
    maskLayer.endPoint = CGPointMake(0.9f, 0.0f);
    UIColor *outerColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    UIColor *innerColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    maskLayer.colors = @[(id)outerColor.CGColor, (id)outerColor.CGColor, (id)innerColor.CGColor, (id)innerColor.CGColor];
    
    maskLayer.locations = @[@0.0, @0.05, @0.5, @1.0f];
    maskLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    maskLayer.anchorPoint = CGPointZero;
    
    containerView.layer.mask = maskLayer;
    
    
    
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, CGRectGetHeight(self.view.bounds) - 30.0f, 60.0f, 20.0f)];
    testLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    testLabel.backgroundColor = [UIColor clearColor];
    testLabel.text = @"Howdy!";
    [self.view addSubview:testLabel];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
