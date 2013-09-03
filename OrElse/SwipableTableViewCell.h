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

- (void)didSwipeCellWithIndexPath:(NSIndexPath *)indexPath;
- (void)didPressLeftCellButton:(id)sender;
- (void)didPressRightCellButton;

@end


@interface SwipableTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *taskLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id <SwipeableTableViewCellProtocol> delegate;
@property (assign, nonatomic) SwipeCellDirection cellDirection;

- (void)returnCellToCentre;

@end
