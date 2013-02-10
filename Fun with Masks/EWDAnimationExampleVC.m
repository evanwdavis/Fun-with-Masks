//
//  EWDAnimationExampleVC.m
//  Fun with Masks
//
//  Created by Evan Davis on 2/8/13.
//  Copyright (c) 2013 Evan Davis. All rights reserved.
//

#import "EWDAnimationExampleVC.h"
#import <QuartzCore/QuartzCore.h>

@interface EWDAnimationExampleVC ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, assign) BOOL isMaskMoved;

@end

@implementation EWDAnimationExampleVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Animation";
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pw_maze_white"]];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    UIImage *theImage = [UIImage imageNamed:@"sample_profile_bg.jpg"];
    UIImageView *bigImage = [[UIImageView alloc] initWithImage:theImage];
    bigImage.image = theImage;
    bigImage.contentMode = UIViewContentModeScaleAspectFill;
    bigImage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [scrollView addSubview:bigImage];
    
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(bigImage.bounds), CGRectGetHeight(bigImage.bounds) - 49.0f)];
    [self.view addSubview:scrollView];
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 100.0f)];
    self.maskView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.maskView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0.0f, 0.0f, 100.0f, 44.0f);
    [button setTitle:@"Move Mask" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toggleMask:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.center = self.view.center;
    
    [self toggleMask:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleMask:(id)sender
{
    self.isMaskMoved = !self.isMaskMoved;
    CGFloat width = self.maskView.layer.frame.size.width;
    CGFloat height = self.maskView.layer.frame.size.height;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, width, 0);
    CGPathAddLineToPoint(path, NULL, width, height);
    CGPathAddLineToPoint(path, NULL, (width / 2) + 30, height);
    if (self.isMaskMoved)
        CGPathAddLineToPoint(path, NULL, (width / 2), height - 30);
    else
        CGPathAddLineToPoint(path, NULL, (width / 2), height);
    CGPathAddLineToPoint(path, NULL, (width / 2) - 30, height);
    CGPathAddLineToPoint(path, NULL, 0, height);
    CGPathCloseSubpath(path);
    
    
    if (!self.maskLayer)
    {
        self.maskLayer = [[CAShapeLayer alloc] init];
        self.maskLayer.frame = self.maskView.layer.bounds;
        self.maskLayer.fillColor = [[UIColor blackColor] CGColor];
        self.maskLayer.path = path;
        
        self.maskView.layer.mask = self.maskLayer;
    }
    else
    {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        [anim setFromValue:(id)self.maskLayer.path];
        [anim setToValue:(__bridge id)(path)];
        [anim setDelegate:self];
        [anim setDuration:0.25];
        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        self.maskLayer.path = path;
        [self.maskLayer addAnimation:anim forKey:@"path"];
    }
    
    CGPathRelease(path);
}

@end
