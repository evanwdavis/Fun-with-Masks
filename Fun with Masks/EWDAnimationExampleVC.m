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

@property (nonatomic, weak) IBOutlet UIView *maskView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, assign) BOOL isMaskMoved;

- (IBAction)toggleMask:(id)sender;

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pw_maze_white"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = self.imageView.bounds.size;
    [self toggleMask:nil];
}

- (IBAction)toggleMask:(id)sender
{
    self.isMaskMoved = !self.isMaskMoved;
    CGFloat width = self.maskView.layer.frame.size.width;
    CGFloat height = self.maskView.layer.frame.size.height;
    
    //Create path that defines the edges of our masking layer
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
    
    //if no mask, create it
    if (!self.maskLayer)
    {
        self.maskLayer = [[CAShapeLayer alloc] init];
        self.maskLayer.frame = self.maskView.layer.bounds;
        self.maskLayer.fillColor = [[UIColor blackColor] CGColor];
        self.maskLayer.path = path;
        self.maskView.layer.mask = self.maskLayer;
    }
    //animate our mask to the new path 
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
