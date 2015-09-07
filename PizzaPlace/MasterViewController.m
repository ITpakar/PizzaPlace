//
//  MasterViewController.m
//  PizzaPlace
//
//  Created by andikabijaya on 9/7/15.
//  Copyright (c) 2015 test. All rights reserved.
//
#define kCLIENTID @"Z0CPGZNBQNXOO2EQOMVT4HSF1HWI3NNZA4GL1OTJG45RBKWB"
#define kCLIENTSECRET @"M3CZGSXTKCKBUOYY0IVG3Z2UPKPWCAR3C4ASNLIN4EUDQFWA"
#import <MagicalRecord/MagicalRecord.h>
#import <CoreLocation/CoreLocation.h>
#import "NSManagedObject+MagicalRecord.h"
#import "AFNetworking.h"
#import "PizzaPlace.h"
#import "PizzaPlaceCell.h"
#import "DetailViewController.h"
#import "MasterViewController.h"

@interface MasterViewController() <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSMutableArray *places;
}


@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return places.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PizzaPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PizzaPlaceCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PizzaPlaceCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    // Configure the cell...
    PizzaPlace *place = [places objectAtIndex:indexPath.row];
    cell.nameLabel.text = place.name;
    cell.addressLabel.text = place.address;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@ mi away", place.distance];
    cell.checkedinCountsLabel.text = [NSString stringWithFormat:@"%@ users checked in", place.checkinsCount];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ShowDetailView" sender:nil];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    if (currentLocation == nil) {
        currentLocation = newLocation;
        
        if (currentLocation != nil) {
            [self loadPizzaPlaces];
        }
    }
    
    [locationManager stopUpdatingLocation];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowDetailView"]) {
        DetailViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PizzaPlace *place = [places objectAtIndex:indexPath.row];
        vc.place = place;
    }
}


#pragma mark - Custom Helpers
- (void)loadPizzaPlaces {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=%@&client_secret=%@&v=20130815&ll=%f,%f&query=pizza", kCLIENTID, kCLIENTSECRET, currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    places = [NSMutableArray array];
    __weak MasterViewController *weakSelf = self;
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDictionary = responseObject;
        NSArray *venues = responseDictionary[@"response"][@"venues"];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            for (NSDictionary *venue in venues) {
                PizzaPlace *place = [PizzaPlace MR_createEntity];
                place.name = venue[@"name"];
                place.address = [venue[@"location"][@"formattedAddress"] componentsJoinedByString:@" "];
                place.distance = venue[@"location"][@"distance"];
                place.checkinsCount = venue[@"stats"][@"checkinsCount"];
                
                [places addObject:place];
            }
        } completion:^(BOOL contextDidSave, NSError *error) {
            
            if (weakSelf) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
