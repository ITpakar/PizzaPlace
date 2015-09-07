//
//  PizzaPlace.h
//  PizzaPlace
//
//  Created by andikabijaya on 9/8/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PizzaPlace : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * checkinsCount;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * name;

@end
