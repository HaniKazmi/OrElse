//
//  SwipeCell.m
//  OrElse
//
//  Created by Hani Kazmi on 03/08/2013.
//  Copyright (c) 2013 Hani Kazmi. All rights reserved.
//

#import "SwipableTableViewCell.h"


static CGFloat const kSwipeButtonWidth = 68.0;
static NSTimeInterval const kReturnSwipeDuration = 0.20;


@interface SwipableTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (assign, nonatomic) CGPoint originalCentre;
@property (strong, nonatomic) UIButton* timeButton;

@end


@implementation SwipableTableViewCell

#pragma mark - Properties

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.cellDirection == SwipeCellDirectionNone) {
        [super setSelected:selected animated:animated];
    } else {
        [self returnCellToCentre];
    }
}

- (UILabel *)taskLabel
{
    if (!_taskLabel) {
        _taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(340, 0, 280, 57.5)];
    }
    return _taskLabel;
}


#pragma mark - View Lifecycle

-(void)awakeFromNib
{
    [super awakeFromNib];

    // Set default swipe position
    self.cellDirection = SwipeCellDirectionNone;

    // Add buttons to swipe view
    [self layoutSwipeView];

    // Create the gesture recognizer
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
    [self.topView addSubview:self.taskLabel];
}

#define ktopViewSize self.topView.frame.size.width/3
#define kTopViewBounds self.topView.bounds
- (void)layoutSwipeView
{
    // Add tick image to right
    UIImage *tickImage = [UIImage imageNamed:@"Check"];
    UIButton *tickButton = [[UIButton alloc] initWithFrame:CGRectMake(kTopViewBounds.origin.x,
                                                                      kTopViewBounds.origin.y,
                                                                      ktopViewSize,
                                                                      kTopViewBounds.size.height)];
    [tickButton setImage:tickImage forState:UIControlStateNormal];
    tickButton.backgroundColor = [UIColor greenColor];
    tickButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    tickButton.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                  0,
                                                  0,
                                                  (kSwipeButtonWidth-tickImage.size.width)/2);
    [tickButton addTarget:self.delegate action:@selector(didPressLeftCellButton:) forControlEvents:UIControlEventTouchDown];
    [self.topView addSubview:tickButton];

    // Add clock image to left
    UIImage *timeImage = [UIImage imageNamed:@"Clock"];
    UIButton *timeButton = [[UIButton alloc] initWithFrame:CGRectMake(2 * ktopViewSize,
                                                                      kTopViewBounds.origin.y,
                                                                      kTopViewBounds.size.width,
                                                                      kTopViewBounds.size.height)];

    [timeButton setImage:timeImage forState:UIControlStateNormal];
    timeButton.backgroundColor = [UIColor blueColor];
    timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    timeButton.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                  (kSwipeButtonWidth-timeImage.size.width)/2,
                                                  0,
                                                  0);
    [timeButton addTarget:self action:@selector(didPressRightCellButton) forControlEvents:UIControlEventTouchDown];
    [self.topView addSubview:timeButton];
    self.timeButton = timeButton;
}

-(void)didPressRightCellButton
{
    NSLog(@"eas");
}


#pragma mark - Gesture Delegates

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{

    if ([[gestureRecognizer class] isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [gestureRecognizer translationInView:[self superview]];
        // Check for horizontal gesture
        return fabsf(translation.x) > fabsf(translation.y) ? YES : NO;
    }

    return YES;
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    // If the gesture has just started, reset cell to default and record the current centre location
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.originalCentre = self.topView.center;
        [self setSelected:NO];
        [self.delegate didSwipeCellWithIndexPath:self.indexPath];
    }

    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Translate the center
        CGPoint translation = [recognizer translationInView:self];
        self.topView.center = CGPointMake(self.originalCentre.x + translation.x, self.originalCentre.y);

        // Determine whether the item has been dragged far enough to initiate an action
        if (self.topView.frame.origin.x > -ktopViewSize + kSwipeButtonWidth) {
            self.cellDirection = SwipeCellDirectionLeft;
        } else if (self.topView.frame.origin.x < -ktopViewSize - kSwipeButtonWidth) {
            self.cellDirection = SwipeCellDirectionRight;
        } else {
            self.cellDirection = SwipeCellDirectionNone;
        }

        float cueAlpha = fabsf((self.topView.frame.origin.x + ktopViewSize) / kSwipeButtonWidth);
        self.timeButton.alpha = cueAlpha;
    }

    else if (recognizer.state == UIGestureRecognizerStateEnded) {

        // Final position of frame for each option
        CGFloat (^value)(SwipeCellDirection) = ^(SwipeCellDirection direction){
            switch (direction) {
                case SwipeCellDirectionLeft:
                    return kSwipeButtonWidth;

                case SwipeCellDirectionRight:
                    return -kSwipeButtonWidth;

                case SwipeCellDirectionNone:
                default:
                    return self.frame.origin.x;
            }
        };

        // Animate the topview after dragging has finished
        [UIView animateWithDuration:kReturnSwipeDuration
                         animations:^{
                             [self.topView setFrame:CGRectMake(value(self.cellDirection) - ktopViewSize,
                                                               kTopViewBounds.origin.y,
                                                               kTopViewBounds.size.width,
                                                               kTopViewBounds.size.height)];
                         }];
    }
}


#pragma mark - Protocol Delegates

- (void)returnCellToCentre
{
    [UIView animateWithDuration:0.50
                     animations:^{
                         //      self.swipeView.alpha = 0.0;
                         [self.topView setFrame:CGRectMake(-ktopViewSize,
                                                           kTopViewBounds.origin.y,
                                                           kTopViewBounds.size.width,
                                                           kTopViewBounds.size.height)];
                         
                     }];
    self.cellDirection = SwipeCellDirectionNone;
}

@end
