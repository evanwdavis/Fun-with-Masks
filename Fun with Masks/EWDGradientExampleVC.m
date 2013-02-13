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
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.scrollEnabled = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pw_maze_white"]];
    
    [self createGradientMask];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = self.bigImageView.bounds.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Mask Creation
- (void)createGradientMask
{
    //creating our gradient mask
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    
    //this is the anchor point for our gradient, in our case top left. setting it in the middle (.5, .5) will produce a radial gradient. our startPoint and endPoints are based off the anchorPoint
    maskLayer.anchorPoint = CGPointZero;
    
    //The line between these two points is the line our gradient uses as a guide
    //starts in bottom left
    maskLayer.startPoint = CGPointMake(0.0f, 1.0f);
    //ends in top right
    maskLayer.endPoint = CGPointMake(1.f, 0.0f);
    
    
    //setting our colors - since this is a mask the color itself is irrelevant - all that matters is the alpha. A clear color will completely hide the layer we're masking, an alpha of 1.0 will completely show the masked view.
    UIColor *outerColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    UIColor *innerColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    //an array of colors that dictatates the gradient(s)
    maskLayer.colors = @[(id)outerColor.CGColor, (id)outerColor.CGColor, (id)innerColor.CGColor, (id)innerColor.CGColor];
    //these are percentage points along the line defined by our startPoint and endPoint and correspond to our colors array. The gradient will shift between the colors between these percentage points.
    maskLayer.locations = @[@0.0, @0.15, @0.5, @1.0f];
    
    maskLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    self.containerView.layer.mask = maskLayer;
}


@end
