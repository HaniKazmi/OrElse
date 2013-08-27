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

-(void)didSwipeCellWithIndexPath:(NSIndexPath *)indexPath;

@end


@interface SwipableTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id <SwipeableTableViewCellProtocol> delegate;
@property (assign, nonatomic) SwipeCellDirection cellDirection;

- (void)returnCellToCentre;

@end
