//
//  SwipeCell.h
//  OrElse
//
//  Created by Hani Kazmi on 03/08/2013.
//  Copyright (c) 2013 Hani Kazmi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SwipeCellDirection) {
    SwipeCellDirectionLeft,
    SwipeCellDirectionNone,
    SwipeCellDirectionRight
};


@protocol SwipeableTableViewCellProtocol <NSObject>

-(void)didSwipeRightInCellWithIndexPath:(NSIndexPath *)indexPath;
-(void)didSwipeLeftInCellWithIndexPath:(NSIndexPath *)indexPath;

@end


@interface SwipableTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) id <SwipeableTableViewCellProtocol> delegate;
@property (nonatomic) SwipeCellDirection cellDirection;

-(IBAction)didSwipeRightInCell:(id)sender;
-(IBAction)didSwipeLeftInCell:(id)sender;
-(void)returnCellToCentre;

@end
