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

@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, assign) CGRect buttonFrame;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *originalImageView;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIImageView *blurView;

- (IBAction)toggleMask:(id)sender;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pw_maze_white"]];
    [self setupBlurredImage];
    
    
    
    //this is the frame we offset in scrollViewDidScroll
    self.buttonFrame = [self.view convertRect:self.testButton.frame toView:self.blurView];
    
    //setting up button
    self.testButton.layer.borderWidth = 2.0f;
    self.testButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.testButton.layer.cornerRadius = CGRectGetHeight(self.testButton.bounds) / 2;
    
    //setting up corresponding mask for the button.
    self.maskLayer = [CALayer layer];
    self.maskLayer.frame = self.buttonFrame;
    self.maskLayer.cornerRadius = self.testButton.layer.cornerRadius;
    self.maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.blurView.layer.mask = self.maskLayer;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = self.originalImageView.bounds.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - mask manipulation

- (IBAction)toggleMask:(id)sender
{
    if (self.blurView.layer.mask)
        self.blurView.layer.mask = nil;
    else
        self.blurView.layer.mask = self.maskLayer;
}

#pragma mark - Image Blurring

- (void)setupBlurredImage
{
    UIImage *theImage = [UIImage imageNamed:@"sample_profile_bg.jpg"];
    
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
    self.blurView.image = [UIImage imageWithCGImage:cgImage];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    CGRect buttonFrame = self.buttonFrame;
    buttonFrame.origin.x += offset.x;
    buttonFrame.origin.y += offset.y;
    NSLog(@"button's frame: %f, %f, %f, %f", buttonFrame.origin.x, buttonFrame.origin.y, buttonFrame.size.width, buttonFrame.size.height);
    //without the CATransaction the mask's frame setting is actually slighty animated, appearing to give it a delay as we scroll around
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.maskLayer.frame = buttonFrame;
    [CATransaction commit];
}

@end
