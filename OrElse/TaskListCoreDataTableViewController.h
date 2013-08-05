//
//  TaskListCoreDataTableViewController.h
//  OrElse
//
//  Created by Hani Kazmi on 03/08/2013.
//  Copyright (c) 2013 Hani Kazmi. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "SwipeCellProtocol.h"

@interface TaskListCoreDataTableViewController : CoreDataTableViewController <SwipeCellProtocol>

- (IBAction)myCancelUnwindSegueCallback:(UIStoryboardSegue *)segue;
- (IBAction)mySaveUnwindSegueCallback:(UIStoryboardSegue *)segue;

@end
