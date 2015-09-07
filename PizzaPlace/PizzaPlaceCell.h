//
//  PizzaPlaceCell.h
//  PizzaPlace
//
//  Created by andikabijaya on 9/8/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PizzaPlaceCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *checkedinCountsLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@end
