//
//  SwipeCell.m
//  OrElse
//
//  Created by Hani Kazmi on 03/08/2013.
//  Copyright (c) 2013 Hani Kazmi. All rights reserved.
//

#import "SwipableTableViewCell.h"


static CGFloat const kSwipeButtonWidth = 68.0;


@interface SwipableTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *swipeView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (assign, nonatomic) CGPoint originalCentre;
@property (strong, nonatomic) UIButton* timeButton;
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
        //           [self layoutSwipeView];
        // Set default swipe position
        self.cellDirection = SwipeCellDirectionNone;
        // Create the gesture recognizers

        UIPanGestureRecognizer *gestureRecoginizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handlePan:)];

        [self addGestureRecognizer:gestureRecoginizer];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Add buttons to the swipe view
    [self layoutSwipeView];
    // Prevent selection highlighting
    //  [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)layoutSwipeView
{
    // Remove previous subviews
    [[self.swipeView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (![self isSelected]) {


        // Add tick image to right
        UIImage *tickImage = [UIImage imageNamed:@"Check"];
        UIButton *tickButton = [[UIButton alloc] initWithFrame:CGRectMake(-self.topView.frame.size.width,
                                                                          0,
                                                                          self.topView.frame.size.width,
                                                                          self.swipeView.frame.size.height)];
        [tickButton setImage:tickImage forState:UIControlStateNormal];
        tickButton.backgroundColor = [UIColor greenColor];
        tickButton.imageView.center = CGPointMake(self.topView.frame.size.width - kSwipeButtonWidth/2, tickButton.center.y);
        [self.topView addSubview:tickButton];

        // Add clock image to left
        UIImage *timeImage = [UIImage imageNamed:@"Clock"];
        UIButton *timeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.swipeView.frame.size.width,
                                                                          0,
                                                                          self.topView.frame.size.width,
                                                                          self.swipeView.frame.size.height)];
        //        self.swipeView.alpha = 0.0;
        [timeButton setImage:timeImage forState:UIControlStateNormal];
        timeButton.backgroundColor = [UIColor blueColor];
                timeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -68, 0, 68);
        timeButton.imageView.center = CGPointMake(kSwipeButtonWidth/2, timeButton.center.y);
        [self.topView addSubview:timeButton];
        self.timeButton = timeButton;
    }

}


#pragma mark - Gesture delegates

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {

    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    // Check for horizontal gesture
    return fabsf(translation.x) > fabsf(translation.y) ? YES : NO;
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // if the gesture has just started, record the current centre location
        self.originalCentre = self.topView.center;

        [self.delegate didSwipeCellWithIndexPath:self.indexPath];
    }

    // 2
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        // translate the center
        CGPoint translation = [recognizer translationInView:self];
        self.topView.center = CGPointMake(self.originalCentre.x + translation.x, self.originalCentre.y);
        // determine whether the item has been dragged far enough to initiate a delete / complete
        if (self.topView.frame.origin.x < -kSwipeButtonWidth) {
            self.cellDirection = SwipeCellDirectionLeft;
        } else if (self.topView.frame.origin.x > kSwipeButtonWidth) {
            self.cellDirection = SwipeCellDirectionRight;
        } else {
            self.cellDirection = SwipeCellDirectionNone;
        }
        float cueAlpha = fabsf(self.topView.frame.origin.x) / kSwipeButtonWidth;
        self.timeButton.alpha = cueAlpha;
    }

    // 3
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, self.topView.frame.origin.y,
                                          self.topView.bounds.size.width, self.topView.bounds.size.height);

        if (self.cellDirection == SwipeCellDirectionNone) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.topView.frame = originalFrame;
                             }
             ];
        } else if (self.cellDirection == SwipeCellDirectionRight){
            [UIView animateWithDuration:0.10
                             animations:^{
                                 [self.topView setFrame:CGRectMake(kSwipeButtonWidth,
                                                                   0,
                                                                   self.contentView.frame.size.width,
                                                                   self.contentView.frame.size.height)];
                             }];
        } else if (self.cellDirection == SwipeCellDirectionLeft){

            [UIView animateWithDuration:0.2
                             animations:^{
                                 [self.topView setFrame:CGRectMake(-kSwipeButtonWidth,
                                                                   0,
                                                                   self.contentView.frame.size.width,
                                                                   self.contentView.frame.size.height)];
                             }
             ];

        }


    }
}

- (void)returnCellToCentre
{
    [UIView animateWithDuration:0.50
                     animations:^{
                   //      self.swipeView.alpha = 0.0;
                         [self.topView setFrame:CGRectMake(0,
                                                           0,
                                                           self.contentView.frame.size.width,
                                                           self.contentView.frame.size.height)];

                     }];
    self.cellDirection = SwipeCellDirectionNone;
}

@end
