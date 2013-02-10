//
//  EWDSecondViewController.m
//  Fun with Masks
//
//  Created by Evan Davis on 2/8/13.
//  Copyright (c) 2013 Evan Davis. All rights reserved.
//

#import "EWDBlurExampleVC.h"
#import <QuartzCore/QuartzCore.h>
@interface EWDBlurExampleVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, assign) CGRect buttonFrame;

@end

@implementation EWDBlurExampleVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Blur";
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
    scrollView.delegate = self;
    
    UIImage *theImage = [UIImage imageNamed:@"sample_profile_bg.jpg"];
    
    UIImageView *bigImage = [[UIImageView alloc] initWithImage:theImage];
    bigImage.contentMode = UIViewContentModeScaleAspectFill;
    bigImage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [scrollView addSubview:bigImage];
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(bigImage.bounds), CGRectGetHeight(bigImage.bounds) - 49.0f)];
    [self.view addSubview:scrollView];
    
    //create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    //setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image 
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    //add our blurred image to the scrollview
    UIImageView *blurView = [[UIImageView alloc] initWithFrame:bigImage.bounds];
    blurView.contentMode = UIViewContentModeScaleAspectFill;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    blurView.image = [UIImage imageWithCGImage:cgImage];
    [scrollView addSubview:blurView];
    
    //this is the frame we offset in scrollViewDidScroll
    self.buttonFrame = CGRectMake(20.0f, 160.0f, CGRectGetWidth(self.view.bounds) - 40.0f, 40.0f);
    
    //setting up button
    self.testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.testButton.frame = self.buttonFrame;
    self.testButton.layer.borderWidth = 2.0f;
    self.testButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.testButton.layer.cornerRadius = CGRectGetHeight(self.testButton.bounds) / 2;
    [self.testButton setTitle:@"Howdy!" forState:UIControlStateNormal];
    [self.testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.testButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [scrollView addSubview:self.testButton];
    
    //setting up corresponding mask for the button. 
    self.maskLayer = [CALayer layer];
    self.maskLayer.frame = self.buttonFrame;
    self.maskLayer.cornerRadius = self.testButton.layer.cornerRadius;
    self.maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    blurView.layer.mask = self.maskLayer;
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    CGRect buttonFrame = self.buttonFrame;
    buttonFrame.origin.x += offset.x;
    buttonFrame.origin.y += offset.y;
    self.testButton.frame = buttonFrame;
    //without the CATransaction the testButton's frame setting is actually slighty animated, appearing to give it a delay as we scroll around
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.maskLayer.frame = buttonFrame;
    [CATransaction commit];
}

@end
