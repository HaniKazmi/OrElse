//
//  SwipeCell.m
//  OrElse
//
//  Created by Hani Kazmi on 03/08/2013.
//  Copyright (c) 2013 Hani Kazmi. All rights reserved.
//

#import "SwipableTableViewCell.h"


@interface SwipableTableViewCell ()

@property (nonatomic, strong) IBOutlet UIView *swipeView;
@property (nonatomic, strong) IBOutlet UIView *topView;

@end


@implementation SwipableTableViewCell

@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.cellDirection = SwipeCellDirectionNone;
        [self.textLabel removeFromSuperview];
        // Initialization code
        [self.contentView setFrame:CGRectMake(0, 0, 320, 58)];
        // Create the top view
        _topView = [[UIView alloc] initWithFrame:self.contentView.frame];
        [_topView setBackgroundColor:[UIColor whiteColor]];
        
        // Create the top label
        [_topView addSubview:self.textLabel];
        
        
        // Create the swipe view
        _swipeView = [[UIView alloc] initWithFrame:self.contentView.frame];
        [_swipeView setBackgroundColor:[UIColor darkGrayColor]];
        
        
        UIView *tickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 68, self.contentView.frame.size.height)];
        tickView.backgroundColor = [UIColor greenColor];
        UIImage *tickImage = [UIImage imageNamed:@"Check"];
        UIImageView *view = [[UIImageView alloc] initWithImage:tickImage];
        view.center = tickView.center;
        [tickView addSubview:view];
        [_swipeView addSubview:tickView];
        
        UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 68, 0, 68, self.contentView.frame.size.height)];
        timeView.backgroundColor = [UIColor blueColor];
        UIImage *timeImage = [UIImage imageNamed:@"Clock"];
        UIImageView *timeImageView = [[UIImageView alloc] initWithImage:timeImage];
        timeImageView.center = CGPointMake(34, 29);
        [timeView addSubview:timeImageView];
        [_swipeView addSubview:timeView];
        // Add views to contentView
        [self.contentView addSubview:_swipeView];
        [self.contentView addSubview:_topView];
        
        // Create the gesture recognizers
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRightInCell:)];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeftInCell:)];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        
        [self addGestureRecognizer:swipeRight];
        [self addGestureRecognizer:swipeLeft];
        
        // Prevent selection highlighting
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        CAGradientLayer *shadow = [CAGradientLayer layer];
        shadow.frame = CGRectMake(-10, 0, 10, _topView.frame.size.height);
        shadow.startPoint = CGPointMake(1.0, 0.5);
        shadow.endPoint = CGPointMake(0, 0.5);
        shadow.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.0 alpha:0.4f] CGColor], (id)[[UIColor clearColor] CGColor], nil];
        [_topView.layer addSublayer:shadow];
        
        CAGradientLayer *rightShadow = [CAGradientLayer layer];
        rightShadow.frame = CGRectMake(_topView.frame.size.width, 0, 10, _topView.frame.size.height);
        rightShadow.startPoint = CGPointMake(0.0, 0.5);
        rightShadow.endPoint = CGPointMake(1.0, 0.5);
        rightShadow.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.0 alpha:0.4f] CGColor], (id)[[UIColor clearColor] CGColor], nil];
        [_topView.layer addSublayer:rightShadow];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)didSwipeRightInCell:(id)sender {
    
    // Inform the delegate of the right swipe
    [delegate didSwipeRightInCellWithIndexPath:_indexPath];
    
    if (self.cellDirection != SwipeCellDirectionLeft) {
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        // Swipe top view left
        [UIView animateWithDuration:0.50 animations:^{
            
            [_topView setFrame:CGRectMake(68, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
            
        } completion:^(BOOL finished) {
            
            // Bounce lower view
            [UIView animateWithDuration:0.10 animations:^{
                
                [_topView setFrame:CGRectMake(64, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
                
            }];
        }];
        self.cellDirection = SwipeCellDirectionRight;
    }
    else {
        
        [self returnCellToCentre];
    }
    
    
}

- (void)returnCellToCentre{
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    [UIView animateWithDuration:0.5 animations:^{
        [_topView setFrame:CGRectMake(-10, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            [_topView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        }];
    }];
    self.cellDirection = SwipeCellDirectionNone;
    
}

-(IBAction)didSwipeLeftInCell:(id)sender {
    
    // Inform the delegate of the left swipe
    [delegate didSwipeLeftInCellWithIndexPath:_indexPath];
    
    if (self.cellDirection != SwipeCellDirectionRight) {
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        // Swipe top view left
        [UIView animateWithDuration:0.50
                         animations:^{
                             [_topView setFrame:CGRectMake(-68,
                                                           0,
                                                           self.contentView.frame.size.width,
                                                           self.contentView.frame.size.height)];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             // Bounce lower view
                             [UIView animateWithDuration:0.10 animations:^{
                                 
                                 [_topView setFrame:CGRectMake(-64, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
                                 
                             }];
                         }];
        self.cellDirection = SwipeCellDirectionLeft;
    }
    else {
        
        [self returnCellToCentre];
    }
}

@end
