//
//  Task.h
//  OrElse
//
//  Created by Hani Kazmi on 04/08/2013.
//  Copyright (c) 2013 Hani Kazmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isCompleted;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;

@end
