//
//  SwipeCell.m
//  OrElse
//
//  Created by Hani Kazmi on 03/08/2013.
//  Copyright (c) 2013 Hani Kazmi. All rights reserved.
//

#import "SwipableTableViewCell.h"


static CGFloat const kSwipeButtonWidth = 68.0;

static CGFloat const kShadowWidth = 10.0;
static CGPoint const kShadowRightPoint = {1.0, 0.5};
static CGPoint const kShadowLeftPoint = {0.0, 0.5};


@interface SwipableTableViewCell ()

@property (nonatomic, strong) IBOutlet UIView *swipeView;
@property (nonatomic, strong) IBOutlet UIView *topView;

@end


@implementation SwipableTableViewCell

@synthesize delegate;

#pragma mark - Properties

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - View Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Set default swipe position
        self.cellDirection = SwipeCellDirectionNone;
        
        // Create the gesture recognizers
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(didSwipeRightInCell:)];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(didSwipeLeftInCell:)];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        
        [self addGestureRecognizer:swipeRight];
        [self addGestureRecognizer:swipeLeft];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Add drop shadow to the top view
    [self layoutTopView];
    
    // Add buttons to the swipe view
    [self layoutSwipeView];
    
    // Prevent selection highlighting
    //  [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)layoutTopView
{
    NSArray *shadowColorArray = @[(id)[[UIColor colorWithWhite:0.0 alpha:0.4f] CGColor],
                                  (id)[[UIColor clearColor] CGColor]];
    
    // Add left shadow
    CAGradientLayer *leftShadow = [CAGradientLayer layer];
    leftShadow.frame = CGRectMake(-kShadowWidth,
                                  0,
                                  kShadowWidth,
                                  self.topView.frame.size.height);
    leftShadow.startPoint = kShadowRightPoint;
    leftShadow.endPoint = kShadowLeftPoint;
    leftShadow.colors = shadowColorArray;
    [self.topView.layer addSublayer:leftShadow];
    
    // Add right shadow
    CAGradientLayer *rightShadow = [CAGradientLayer layer];
    rightShadow.frame = CGRectMake(self.topView.frame.size.width,
                                   0,
                                   kShadowWidth,
                                   self.topView.frame.size.height);
    rightShadow.startPoint = kShadowLeftPoint;
    rightShadow.endPoint = kShadowRightPoint;
    rightShadow.colors = shadowColorArray;
    [self.topView.layer addSublayer:rightShadow];
}

- (void)layoutSwipeView
{
    // Remove previous subviews
    [[self.swipeView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Add tick image to right
    UIImage *tickImage = [UIImage imageNamed:@"Check"];
    UIButton *tickButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      kSwipeButtonWidth,
                                                                      self.swipeView.frame.size.height)];
    [tickButton setImage:tickImage forState:UIControlStateNormal];
    tickButton.backgroundColor = [UIColor greenColor];
    [self.swipeView addSubview:tickButton];
    
    // Add clock image to left
    UIImage *timeImage = [UIImage imageNamed:@"Clock"];
    UIButton *timeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.swipeView.frame.size.width - 68,
                                                                      0,
                                                                      kSwipeButtonWidth,
                                                                      self.swipeView.frame.size.height)];
    [timeButton setImage:timeImage forState:UIControlStateNormal];
    timeButton.backgroundColor = [UIColor blueColor];
    [self.swipeView addSubview:timeButton];
}


#pragma mark - Gesture delegates

-(IBAction)didSwipeRightInCell:(id)sender
{
    // Inform the delegate of the right swipe
    [delegate didSwipeRightInCellWithIndexPath:self.indexPath];
    
    if (self.cellDirection == SwipeCellDirectionLeft) {
        
        [self returnCellToCentre];
    } else {
        // Swipe top view left
        [UIView animateWithDuration:0.50
                         animations:^{
                             [self.topView setFrame:CGRectMake(kSwipeButtonWidth,
                                                           0,
                                                           self.contentView.frame.size.width,
                                                           self.contentView.frame.size.height)];
                         }
                         completion:^(BOOL finished) {
                             // Bounce lower view
                             [UIView animateWithDuration:0.10 animations:^{
                                 [self.topView setFrame:CGRectMake(64,
                                                               0,
                                                               self.contentView.frame.size.width,
                                                               self.contentView.frame.size.height)];
                             }];
                         }];
        self.cellDirection = SwipeCellDirectionRight;
    }
}

- (void)returnCellToCentre
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.topView setFrame:CGRectMake(0,
                                                       0,
                                                       self.contentView.frame.size.width,
                                                       self.contentView.frame.size.height)];
                     }
                     // Bounce lower view
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.15 animations:^{
                             [self.topView setFrame:CGRectMake(0,
                                                           0,
                                                           self.contentView.frame.size.width,
                                                           self.contentView.frame.size.height)];
                         }];
                     }];
    self.cellDirection = SwipeCellDirectionNone;
}

-(IBAction)didSwipeLeftInCell:(id)sender
{
    // Inform the delegate of the left swipe
    [delegate didSwipeLeftInCellWithIndexPath:self.indexPath];
    
    if (self.cellDirection == SwipeCellDirectionRight) {
        [self returnCellToCentre];
    } else {
        // Swipe top view left
        [UIView animateWithDuration:0.50
                         animations:^{
                             [self.topView setFrame:CGRectMake(-kSwipeButtonWidth,
                                                           0,
                                                           self.contentView.frame.size.width,
                                                           self.contentView.frame.size.height)];
                             
                         } completion:^(BOOL finished) {
                             // Bounce lower view
                             [UIView animateWithDuration:0.10 animations:^{
                                 [self.topView setFrame:CGRectMake(-64,
                                                               0,
                                                               self.contentView.frame.size.width,
                                                               self.contentView.frame.size.height)];
                             }];
                         }];
        self.cellDirection = SwipeCellDirectionLeft;
    }
}

@end
