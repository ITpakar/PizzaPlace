//
//  DetailViewController.m
//  PizzaPlace
//
//  Created by andikabijaya on 9/7/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize place;
- (void)viewDidLoad {
    [super viewDidLoad];

    self.nameLabel.text = place.name;
    self.addressLabel.text = place.address;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ mi away", place.distance];
    self.checkedinCountsLabel.text = [NSString stringWithFormat:@"%@ users checked in", place.checkinsCount];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
