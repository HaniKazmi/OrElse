//
//  SwipeCell.m
//  SwipingTable
//
//  Created by Tim Duckett on 13/12/2011.
//  Copyright (c) 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "SwipeCell.h"

@interface SwipeCell ()

@property (nonatomic, strong) IBOutlet UIView *swipeView;
@property (nonatomic, strong) IBOutlet UIView *topView;

@end
@implementation SwipeCell

@synthesize delegate;


- (id)initWithCoder:(NSCoder *)aDecoder {
    
  self = [super initWithCoder:aDecoder];
    if (self) {
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
        
        // Create the swipe label
        UILabel *haveSwipedlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
        [haveSwipedlabel setFont:[UIFont fontWithName:@"GillSans-Bold" size:12]];
        [haveSwipedlabel setTextColor:[UIColor whiteColor]];
        [haveSwipedlabel setBackgroundColor:[UIColor darkGrayColor]];
        [haveSwipedlabel setText:@"I've been swiped!"];
        
        UIView *tickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 68, self.contentView.frame.size.height)];
        tickView.backgroundColor = [UIColor greenColor];
        UIImage *tickImage = [UIImage imageNamed:@"check.png"];
        UIImageView *view = [[UIImageView alloc] initWithImage:tickImage];
        view.center = tickView.center;
        [tickView addSubview:view];
        [_swipeView addSubview:tickView];
        
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
    
}

-(IBAction)didSwipeLeftInCell:(id)sender {
    
    // Inform the delegate of the left swipe
    [delegate didSwipeLeftInCellWithIndexPath:_indexPath];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    [UIView animateWithDuration:0.5 animations:^{
        [_topView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            [_topView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        }];
    }];
    
}

@end
